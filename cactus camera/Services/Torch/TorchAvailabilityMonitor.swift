//
//  TorchAvailabilityMonitor.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import AVFoundation

final class TorchAvailabilityMonitor: ObservableObject {
    enum TorchStatus: Equatable {
        case normal
        case limited
        case unavailable
    }

    @Published private(set) var status: TorchStatus = .unavailable

    private let monitorQueue = DispatchQueue(label: "cactuscamera.torch.monitor.queue")

    private var device: AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    }

    init() {
        updateStatus()
    }

    func updateStatus() {
        monitorQueue.async { [weak self] in
            guard let self else { return }

            guard let device = self.device else {
                DispatchQueue.main.async {
                    self.status = .unavailable
                }
                return
            }

            if device.hasTorch {
                DispatchQueue.main.async {
                    self.status = .normal
                }
            } else {
                DispatchQueue.main.async {
                    self.status = .unavailable
                }
            }
        }
    }

    func markLimited() {
        DispatchQueue.main.async {
            self.status = .limited
        }
    }

    func markUnavailable() {
        DispatchQueue.main.async {
            self.status = .unavailable
        }
    }
}
