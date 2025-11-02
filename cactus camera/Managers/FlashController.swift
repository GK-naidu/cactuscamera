//
//  FlashController.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import AVFoundation

final class FlashController: ObservableObject {
    private let torchQueue = DispatchQueue(label: "cactuscamera.flash.queue")

    private var cachedDevice: AVCaptureDevice? = {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    }()

    private var lastLevel: Float = 0.0
    private var isPulsing = false

    func setTorchLevel(_ level: Float) {
        torchQueue.async {
            guard let device = self.cachedDevice,
                  device.hasTorch else {
                return
            }

            let clamped = max(0, min(level, 1))

            if abs(clamped - self.lastLevel) < 0.05 {
                return
            }

            do {
                try device.lockForConfiguration()

                if clamped <= 0 {
                    if device.isTorchModeSupported(.off) {
                        device.torchMode = .off
                        self.lastLevel = 0
                    }
                } else {
                    if device.isTorchModeSupported(.on) {
                        let targetLevel = min(clamped, AVCaptureDevice.maxAvailableTorchLevel)
                        try device.setTorchModeOn(level: targetLevel)
                        self.lastLevel = targetLevel
                    }
                }

                device.unlockForConfiguration()
            } catch {
                device.unlockForConfiguration()
            }
        }
    }

    func setTorchOff() {
        setTorchLevel(0)
    }

    func quickPulse() {
        torchQueue.async {
            if self.isPulsing {
                return
            }
            self.isPulsing = true

            guard let device = self.cachedDevice,
                  device.hasTorch else {
                self.isPulsing = false
                return
            }

            let restoreLevel = self.lastLevel

            do {
                try device.lockForConfiguration()

                if device.isTorchModeSupported(.on) {
                    let fullLevel = AVCaptureDevice.maxAvailableTorchLevel
                    try device.setTorchModeOn(level: fullLevel)
                }

                device.unlockForConfiguration()
            } catch {
                device.unlockForConfiguration()
                self.isPulsing = false
                return
            }

            usleep(120_000)

            do {
                try device.lockForConfiguration()

                if restoreLevel <= 0 {
                    if device.isTorchModeSupported(.off) {
                        device.torchMode = .off
                        self.lastLevel = 0
                    }
                } else {
                    if device.isTorchModeSupported(.on) {
                        let targetLevel = min(restoreLevel, AVCaptureDevice.maxAvailableTorchLevel)
                        try device.setTorchModeOn(level: targetLevel)
                        self.lastLevel = targetLevel
                    }
                }

                device.unlockForConfiguration()
            } catch {
                device.unlockForConfiguration()
            }

            self.isPulsing = false
        }
    }
}

