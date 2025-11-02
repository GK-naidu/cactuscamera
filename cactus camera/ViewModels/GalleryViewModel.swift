//
//  GalleryViewModel.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import Photos
import UIKit

@MainActor
final class GalleryViewModel: ObservableObject {
    @Published var assets: [GalleryAsset] = []
    private let fetcher: GalleryFetcher

    init(fetcher: GalleryFetcher = GalleryFetcher()) {
        self.fetcher = fetcher
    }

    func refresh() {
        fetcher.fetchRecent { [weak self] result in
            Task { @MainActor in
                self?.assets = result
            }
        }
    }
}

struct GalleryAsset: Identifiable {
    let id: String
    let thumbnail: UIImage?
    let isVideo: Bool
    let durationText: String?
}
