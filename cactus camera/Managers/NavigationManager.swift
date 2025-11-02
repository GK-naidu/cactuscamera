//
//  NavigationManager.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI

final class NavigationManager: ObservableObject {
    @Published var currentTab: AppTab = .camera
}
