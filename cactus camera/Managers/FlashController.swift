//
//  FlashController.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import AVFoundation

final class FlashController: ObservableObject {
    private let torchQueue = DispatchQueue(label: "FlashController.torchQueue")

    func setTorch(active: Bool) throws {
        try torchQueue.sync {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                throw TorchError.deviceUnavailable
            }

            guard device.hasTorch else {
                throw TorchError.deviceUnavailable
            }

            do {
                try device.lockForConfiguration()
                if active {
                    if device.isTorchModeSupported(.on) {
                        try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                    }
                } else {
                    if device.isTorchModeSupported(.off) {
                        device.torchMode = .off
                    }
                }
                device.unlockForConfiguration()
            } catch {
                device.unlockForConfiguration()
                throw TorchError.configurationFailed
            }
        }
    }
}


