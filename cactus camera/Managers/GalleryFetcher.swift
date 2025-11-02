//
//  GalleryFetcher.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import Photos
import UIKit

final class GalleryFetcher {
    private let imageManager = PHImageManager.default()
    private let thumbTargetSize = CGSize(width: 400, height: 400)

    func fetchRecent(limit: Int = 20, completion: @escaping ([GalleryAsset]) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status != .authorized && status != .limited {
            completion([])
            return
        }

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.fetchLimit = limit

        let assets = PHAsset.fetchAssets(with: fetchOptions)

        var result: [GalleryAsset] = []
        let group = DispatchGroup()

        assets.enumerateObjects { phAsset, _, _ in
            group.enter()

            let isVideo = phAsset.mediaType == .video
            let durationText: String?
            if isVideo {
                let totalSeconds = Int(phAsset.duration)
                let minutes = totalSeconds / 60
                let seconds = totalSeconds % 60
                let minutesString = String(format: "%02d", minutes)
                let secondsString = String(format: "%02d", seconds)
                durationText = "\(minutesString):\(secondsString)"
            } else {
                durationText = nil
            }

            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .fast

            self.imageManager.requestImage(
                for: phAsset,
                targetSize: self.thumbTargetSize,
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                let item = GalleryAsset(
                    id: phAsset.localIdentifier,
                    thumbnail: image,
                    isVideo: isVideo,
                    durationText: durationText
                )
                result.append(item)
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(result)
        }
    }
}
