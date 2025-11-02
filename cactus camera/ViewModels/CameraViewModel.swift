//
//  CameraViewModel.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import SwiftUI
import AVFoundation

@MainActor
final class CameraViewModel: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var isStrobeOn: Bool = false

    @Published var recordingState: RecordingState = .idle
    @Published var elapsedDisplayText: String = "00:00"

    @Published var sessionManager: CaptureSessionManager
    @Published var flashController: FlashController

    private var timerTask: Task<Void, Never>?
    private var strobeTask: Task<Void, Never>?

    private var lastTorchUpdateTime: Date = .distantPast
    private let torchUpdateInterval: TimeInterval = 0.1

    private var fastEnv: Float = 0.0
    private var slowEnv: Float = 0.0

    private let fastDecay: Float = 0.5
    private let slowAlpha: Float = 0.05

    private let noiseFloor: Float = 0.05
    private let minSlowFloor: Float = 0.06

    private let minChangeForUpdate: Float = 0.12
    private var lastSentLevel: Float = 0.0

    init(sessionManager: CaptureSessionManager,
         flashController: FlashController) {
        self.sessionManager = sessionManager
        self.flashController = flashController
        self.sessionManager.startSession()
        hookSessionCallbacks()
    }

    private func hookSessionCallbacks() {
        sessionManager.onRecordingDidStart = { [weak self] in
            guard let self else { return }
            guard case .recording = self.recordingState else { return }
            self.startTimer()
            self.startStrobeLoop()
        }

        sessionManager.onRecordingWillStop = { [weak self] in
            guard let self else { return }
            self.stopTimer()
            self.stopStrobeLoop()
        }

        sessionManager.onSavingDidBegin = { [weak self] in
            guard let self else { return }
            self.recordingState = .saving
            self.stopStrobeLoop()
        }

        sessionManager.onSavingDidFinish = { [weak self] success in
            guard let self else { return }
            if success {
                self.recordingState = .idle
                self.isRecording = false
                self.elapsedDisplayText = "00:00"
                Haptics.strong()
            } else {
                self.recordingState = .error(message: "Save failed")
                self.isRecording = false
                Haptics.strong()
            }
            self.stopStrobeLoop()
            self.flashController.setTorchLevel(0)
        }
    }

    private func startStrobeLoop() {
        strobeTask?.cancel()

        strobeTask = Task { [weak self] in
            guard let self else { return }

            self.fastEnv = 0
            self.slowEnv = 0
            self.lastTorchUpdateTime = .distantPast
            self.lastSentLevel = 0

            while !Task.isCancelled {
                if !self.isRecording || !self.isStrobeOn {
                    try? await Task.sleep(nanoseconds: 20_000_000)
                    continue
                }

                let rawLevel = self.sessionManager.currentAudioLevel()
                let clamped = max(0, min(rawLevel, 1))

                self.fastEnv = max(clamped, self.fastEnv * self.fastDecay)
                self.slowEnv = (1 - self.slowAlpha) * self.slowEnv + self.slowAlpha * clamped

                let denom = max(self.slowEnv, self.minSlowFloor)
                let energyAboveBaseline = max(0, self.fastEnv - self.slowEnv)

                var desiredLevel: Float = 0

                if self.fastEnv >= self.noiseFloor {
                    let normalized = min(max(energyAboveBaseline / denom, 0), 1)
                    let mapped = 0.2 + (0.8 * normalized)
                    desiredLevel = mapped
                } else {
                    desiredLevel = 0
                }

                let now = Date()
                let enoughTimePassed = now.timeIntervalSince(self.lastTorchUpdateTime) >= self.torchUpdateInterval
                let levelDelta = abs(desiredLevel - self.lastSentLevel)

                if enoughTimePassed && levelDelta >= self.minChangeForUpdate {
                    self.lastTorchUpdateTime = now
                    self.lastSentLevel = desiredLevel
                    self.flashController.setTorchLevel(desiredLevel)
                }

                try? await Task.sleep(nanoseconds: 20_000_000)
            }
        }
    }

    private func stopStrobeLoop() {
        strobeTask?.cancel()
        strobeTask = nil
        lastSentLevel = 0
        flashController.setTorchLevel(0)
    }

    func toggleRecording() {
        switch recordingState {
        case .idle:
            beginRecording()
        case .recording:
            endRecording()
        default:
            break
        }
    }

    private func beginRecording() {
        let start = Date()
        recordingState = .recording(startedAt: start)
        isRecording = true
        elapsedDisplayText = "00:00"

        fastEnv = 0
        slowEnv = 0
        lastTorchUpdateTime = .distantPast
        lastSentLevel = 0

        sessionManager.startRecording()
        startTimer()
        startStrobeLoop()
        Haptics.strong()
    }

    private func endRecording() {
        stopTimer()
        stopStrobeLoop()
        sessionManager.stopRecording()
    }

    private func startTimer() {
        guard case let .recording(startedAt: startTime) = recordingState else { return }

        timerTask?.cancel()
        timerTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                let formatted = TimeUtils.formatDuration(from: startTime, to: Date())
                await MainActor.run {
                    self.elapsedDisplayText = formatted
                }
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }

    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    func setStrobeEnabled(_ enabled: Bool) {
        isStrobeOn = enabled
        if !enabled {
            flashController.setTorchLevel(0)
        }
    }

    func manualFlashPulse() {
        guard isStrobeOn else { return }
        flashController.quickPulse()
    }

    deinit {
        timerTask?.cancel()
        strobeTask?.cancel()
    }
}


