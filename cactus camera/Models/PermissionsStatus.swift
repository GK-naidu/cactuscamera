//
//  PermissionsStatus.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation

struct PermissionsStatus: Equatable {
    var cameraAuthorized: Bool
    var microphoneAuthorized: Bool
    var photoLibraryAuthorized: Bool
}
