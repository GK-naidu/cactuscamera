//
//  AppStateManager.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import SwiftUI

@MainActor
final class AppStateManager: ObservableObject {
    @Published var recordingState: RecordingState = .idle
    @Published var strobeMode: StrobeMode = .autoBeat
    @Published var permissionsStatus: PermissionsStatus = PermissionsStatus(cameraAuthorized: false, microphoneAuthorized: false, photoLibraryAuthorized: false)

    func updateRecordingState(_ state: RecordingState) {
        recordingState = state
    }

    func updateStrobeMode(_ mode: StrobeMode) {
        strobeMode = mode
    }

    func updatePermissions(_ status: PermissionsStatus) {
        permissionsStatus = status
    }
}
