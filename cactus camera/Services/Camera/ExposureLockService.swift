//
//  ExposureLockService.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import AVFoundation

@MainActor
final class ExposureLockService {
    func lockExposure(device: AVCaptureDevice) throws {
        guard device.isExposureModeSupported(.locked),
              device.isWhiteBalanceModeSupported(.locked) else {
            throw CameraError.configurationFailed
        }

        try device.lockForConfiguration()
        if device.isExposureModeSupported(.locked) {
            device.exposureMode = .locked
        }
        if device.isWhiteBalanceModeSupported(.locked) {
            device.whiteBalanceMode = .locked
        }
        device.unlockForConfiguration()
    }

    func unlockExposure(device: AVCaptureDevice) throws {
        try device.lockForConfiguration()
        if device.isExposureModeSupported(.continuousAutoExposure) {
            device.exposureMode = .continuousAutoExposure
        }
        if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
            device.whiteBalanceMode = .continuousAutoWhiteBalance
        }
        device.unlockForConfiguration()
    }
}
