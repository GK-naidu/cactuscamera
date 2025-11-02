//
//  AppLaunchViewModel.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import SwiftUI
import AVFoundation

@MainActor
final class AppLaunchViewModel: ObservableObject {
    @Published var shouldShowPermissionsGate: Bool = true

    private let permissionsManager: PermissionsManager

    init(permissionsManager: PermissionsManager) {
        self.permissionsManager = permissionsManager

        let current = permissionsManager.status
        shouldShowPermissionsGate = !(
            current.cameraAuthorized &&
            current.microphoneAuthorized &&
            current.photoLibraryAuthorized
        )
    }

    func requestAll(completion: @escaping (Bool) -> Void) {
        permissionsManager.requestAll { [weak self] status in
            Task { @MainActor in
                let granted =
                    status.cameraAuthorized &&
                    status.microphoneAuthorized &&
                    status.photoLibraryAuthorized

                self?.shouldShowPermissionsGate = !granted
                completion(granted)
            }
        }
    }

    func refreshPermissions() {
        permissionsManager.refreshStatus()
        let status = permissionsManager.status
        shouldShowPermissionsGate = !(
            status.cameraAuthorized &&
            status.microphoneAuthorized &&
            status.photoLibraryAuthorized
        )
    }
}
