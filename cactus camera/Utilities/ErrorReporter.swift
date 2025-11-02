//
//  ErrorReporter.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import SwiftUI

@MainActor
final class ErrorReporter: ObservableObject {
    @Published var activeError: CameraError?

    func report(_ error: CameraError) {
        activeError = error
    }

    func clear() {
        activeError = nil
    }

    var message: String {
        guard let activeError else { return "" }
        switch activeError {
        case .cameraUnavailable:
            return "Camera unavailable"
        case .microphoneUnavailable:
            return "Microphone unavailable"
        case .photoLibraryUnavailable:
            return "Photo library unavailable"
        case .configurationFailed:
            return "Failed to configure capture session"
        case .recordingFailed:
            return "Recording failed"
        case .savingFailed:
            return "Save failed"
        case .torchUnavailable:
            return "Torch unavailable"
        case .torchRestricted:
            return "Torch restricted"
        case .permissionDenied:
            return "Permission denied"
        case .unknown:
            return "Unknown error"
        }
    }
}
