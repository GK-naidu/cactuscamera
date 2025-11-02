//
//  AudioReactiveEngine.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import AVFoundation
import Combine

final class AudioReactiveEngine: ObservableObject {
    @Published private(set) var peakLevel: Float = 0.0

    private let engine = AVAudioEngine()
    private let session = AVAudioSession.sharedInstance()
    private let processingQueue = DispatchQueue(label: "AudioReactiveEngine.processingQueue")

    private var isRunning = false

    func start() throws {
        if isRunning {
            return
        }

        try session.setCategory(.playAndRecord, mode: .videoRecording, options: [.defaultToSpeaker, .allowBluetooth])
        try session.setActive(true)

        let inputNode = engine.inputNode
        let format = inputNode.inputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self else { return }
            self.processingQueue.async {
                self.handleBuffer(buffer: buffer)
            }
        }

        engine.prepare()
        try engine.start()

        isRunning = true
    }

    func stop() {
        if !isRunning {
            return
        }

        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        try? session.setActive(false, options: .notifyOthersOnDeactivation)

        isRunning = false
        DispatchQueue.main.async {
            self.peakLevel = 0.0
        }
    }

    private func handleBuffer(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData else { return }
        let channelCount = Int(buffer.format.channelCount)
        let frameLength = Int(buffer.frameLength)

        var maxAmp: Float = 0.0

        for channel in 0..<channelCount {
            let samples = channelData[channel]
            var localMax: Float = 0.0
            var i = 0
            while i < frameLength {
                let sample = abs(samples[i])
                if sample > localMax {
                    localMax = sample
                }
                i += 1
            }
            if localMax > maxAmp {
                maxAmp = localMax
            }
        }

        let clamped = max(0.0, min(maxAmp, 1.0))

        DispatchQueue.main.async {
            self.peakLevel = clamped
        }
    }
}

