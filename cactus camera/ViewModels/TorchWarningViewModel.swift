//
//  TorchWarningViewModel.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import Combine

@MainActor
final class TorchWarningViewModel: ObservableObject {
    @Published var showWarning: Bool = false
    @Published var warningText: String = ""

    private var monitor: TorchAvailabilityMonitor?
    private var cancellable: AnyCancellable?

    init(monitor: TorchAvailabilityMonitor? = nil) {
        self.monitor = monitor
        bindMonitor()
    }

    func bindMonitor() {
        guard let monitor = monitor else { return }
        cancellable = monitor.$status.sink { [weak self] status in
            guard let self else { return }
            switch status {
            case .normal:
                self.showWarning = false
                self.warningText = ""
            case .limited:
                self.showWarning = true
                self.warningText = "Torch performance reduced"
            case .unavailable:
                self.showWarning = true
                self.warningText = "Torch unavailable"
            }
        }
    }
}
