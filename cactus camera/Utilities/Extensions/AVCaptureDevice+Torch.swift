//
//  AVCaptureDevice+Torch.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import AVFoundation

extension AVCaptureDevice {
    func setTorch(active: Bool, level: Float? = nil) throws {
        guard hasTorch else {
            throw CameraError.torchUnavailable
        }

        try lockForConfiguration()
        if active {
            if let level = level {
                let clamped = max(0.01, min(level, AVCaptureDevice.maxAvailableTorchLevel))
                try setTorchModeOn(level: clamped)
            } else {
                try setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }
        } else {
            torchMode = .off
        }
        unlockForConfiguration()
    }
}
