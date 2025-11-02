//
//  AudioSessionConfigurator.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import AVFoundation

@MainActor
final class AudioSessionConfigurator {
    static let shared = AudioSessionConfigurator()

    private let session = AVAudioSession.sharedInstance()

    func configureForCapture() throws {
        try session.setCategory(.playAndRecord, mode: .videoRecording, options: [.mixWithOthers, .defaultToSpeaker, .allowBluetooth])
        try session.setActive(true)
    }

    func deactivate() {
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
    }
}
