//
//  MediaSavingService.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import Photos
import AVFoundation
import UIKit

@MainActor
final class MediaSavingService: ObservableObject {
    func saveVideo(at url: URL, completion: @escaping (Result<Void, CameraError>) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    completion(.failure(.photoLibraryUnavailable))
                }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }, completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success {
                        completion(.success(()))
                    } else {
                        completion(.failure(.savingFailed))
                    }
                }
            })
        }
    }

    func saveImage(_ image: UIImage, completion: @escaping (Result<Void, CameraError>) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    completion(.failure(.photoLibraryUnavailable))
                }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success {
                        completion(.success(()))
                    } else {
                        completion(.failure(.savingFailed))
                    }
                }
            })
        }
    }
}
