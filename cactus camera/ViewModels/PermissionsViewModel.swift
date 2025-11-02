//
//  PermissionsViewModel.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import Photos
import AVFoundation

@MainActor
final class PermissionsViewModel: ObservableObject {
    @Published private(set) var status: PermissionsStatus

    private let manager: PermissionsManager

    init(manager: PermissionsManager) {
        self.manager = manager
        self.status = manager.status
    }

    func refresh() {
        manager.refreshStatus()
        status = manager.status
    }

    func requestAll(completion: @escaping (PermissionsStatus) -> Void) {
        manager.requestAll { [weak self] newStatus in
            Task { @MainActor in
                self?.status = newStatus
                completion(newStatus)
            }
        }
    }

    var allGranted: Bool {
        status.cameraAuthorized &&
        status.microphoneAuthorized &&
        status.photoLibraryAuthorized
    }
}
