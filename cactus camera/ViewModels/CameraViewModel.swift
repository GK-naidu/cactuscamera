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
    @Published var audioEngine: AudioReactiveEngine

    private var timerTask: Task<Void, Never>?
    private var strobeTask: Task<Void, Never>?

    init(sessionManager: CaptureSessionManager,
         flashController: FlashController,
         audioEngine: AudioReactiveEngine) {
        self.sessionManager = sessionManager
        self.flashController = flashController
        self.audioEngine = audioEngine
        self.sessionManager.startSession()
        hookSessionCallbacks()
    }

    private func hookSessionCallbacks() {
        sessionManager.onRecordingDidStart = { [weak self] in
            guard let self else { return }
            guard case .recording = self.recordingState else { return }
            self.startTimer()
            self.startStrobeLoopIfNeeded()
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
            Task {
                try? self.flashController.setTorch(active: false)
            }
        }
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
        sessionManager.startRecording()
        startTimer()
        startStrobeLoopIfNeeded()
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
            stopStrobeLoop()
            Task {
                try? flashController.setTorch(active: false)
            }
        } else {
            if isRecording {
                startStrobeLoopIfNeeded()
            }
        }
    }

    private func startStrobeLoopIfNeeded() {
        if !isStrobeOn {
            return
        }
        if strobeTask != nil {
            return
        }

        try? audioEngine.start()

        strobeTask = Task { [weak self] in
            guard let self else { return }

            var lastFlashTime = Date.distantPast
            let minInterval: TimeInterval = 0.15
            let threshold: Float = 0.6

            while !Task.isCancelled {
                if !self.isStrobeOn || !self.isRecording {
                    try? await Task.sleep(nanoseconds: 50_000_000)
                    continue
                }

                let level = self.audioEngine.peakLevel
                let now = Date()

                if level >= threshold && now.timeIntervalSince(lastFlashTime) >= minInterval {
                    await self.pulseTorch()
                    lastFlashTime = now
                }

                try? await Task.sleep(nanoseconds: 50_000_000)
            }
        }
    }

    private func stopStrobeLoop() {
        strobeTask?.cancel()
        strobeTask = nil
        audioEngine.stop()
    }

    private func pulseTorch() async {
        try? flashController.setTorch(active: true)
        try? await Task.sleep(nanoseconds: 120_000_000)
        try? flashController.setTorch(active: false)
    }

    deinit {
        timerTask?.cancel()
        strobeTask?.cancel()
    }
}




