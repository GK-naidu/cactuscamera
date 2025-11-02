//
//  CameraError.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation

enum CameraError: Error, Equatable {
    case cameraUnavailable
    case microphoneUnavailable
    case photoLibraryUnavailable
    case configurationFailed
    case recordingFailed
    case savingFailed
    case torchUnavailable
    case torchRestricted
    case permissionDenied
    case unknown
}
