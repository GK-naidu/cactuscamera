//
//  SettingsViewModel.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var autoStrobeSync: Bool = true
    @Published var lockExposure: Bool = false
    @Published var autoSaveToPhotos: Bool = true
    @Published var strobeModeLabel: String = "Auto • Manual • Off"
    @Published var brandOverlayEnabled: Bool = false
    @Published var audioInputModeLabel: String = "Concert Optimized"
    @Published var versionLabel: String = "Version 1.0"
}
