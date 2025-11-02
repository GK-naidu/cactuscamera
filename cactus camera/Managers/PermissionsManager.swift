//
//  PermissionsManager.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import SwiftUI
import AVFoundation
import Photos

@MainActor
final class PermissionsManager: ObservableObject {
    @Published private(set) var status: PermissionsStatus = PermissionsStatus(
        cameraAuthorized: false,
        microphoneAuthorized: false,
        photoLibraryAuthorized: false
    )

    init() {
        refreshStatus()
    }

    func refreshStatus() {
        let cameraAuth = AVCaptureDevice.authorizationStatus(for: .video)
        let micAuth = AVCaptureDevice.authorizationStatus(for: .audio)

        let photoAuth = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        status = PermissionsStatus(
            cameraAuthorized: cameraAuth == .authorized,
            microphoneAuthorized: micAuth == .authorized,
            photoLibraryAuthorized: (photoAuth == .authorized || photoAuth == .limited)
        )
    }

    func requestAll(completion: @escaping (PermissionsStatus) -> Void) {
        Task {
            let cameraGranted = await requestCamera()
            let micGranted = await requestMic()
            let photosGranted = await requestPhotos()

            let newStatus = PermissionsStatus(
                cameraAuthorized: cameraGranted,
                microphoneAuthorized: micGranted,
                photoLibraryAuthorized: photosGranted
            )

            status = newStatus
            completion(newStatus)
        }
    }

    private func requestCamera() async -> Bool {
        await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                continuation.resume(returning: granted)
            }
        }
    }

    private func requestMic() async -> Bool {
        await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                continuation.resume(returning: granted)
            }
        }
    }

    private func requestPhotos() async -> Bool {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { auth in
                let allowed = (auth == .authorized || auth == .limited)
                continuation.resume(returning: allowed)
            }
        }
    }
}


