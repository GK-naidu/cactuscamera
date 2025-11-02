//
//  Enum.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation

enum AppTab: Hashable {
    case gallery
    case camera
    case settings
}

enum StrobeMode: Equatable {
    case off
    case manualTap
    case autoBeat
}


enum RecordingState: Equatable {
    case idle
    case recording(startedAt: Date)
    case saving
    case error(message: String)
}



enum AppScreen: Equatable {
    case permissions
    case main
}

enum TorchError: Error {
    case deviceUnavailable
    case configurationFailed
}
