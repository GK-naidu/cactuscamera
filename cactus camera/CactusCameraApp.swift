//
//  cactus_cameraApp.swift
//  cactus camera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI

@main
struct CactusCameraApp: App {
    @StateObject private var navigationManager = NavigationManager()

    @StateObject private var permissionsManager  : PermissionsManager
    @StateObject private var appLaunchViewModel  : AppLaunchViewModel
    @StateObject private var permissionsViewModel: PermissionsViewModel

    @StateObject private var cameraViewModel   : CameraViewModel
    @StateObject private var settingsViewModel : SettingsViewModel

    init() {
        let permManager = PermissionsManager()
        _permissionsManager = StateObject(wrappedValue: permManager)
        _appLaunchViewModel = StateObject(wrappedValue: AppLaunchViewModel(permissionsManager: permManager))
        _permissionsViewModel = StateObject(wrappedValue: PermissionsViewModel(manager: permManager))

        let sessionMgr = CaptureSessionManager()
        let flashCtrl = FlashController()
        
        _cameraViewModel = StateObject(wrappedValue: CameraViewModel(sessionManager: sessionMgr, flashController: flashCtrl))

        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel())
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(navigationManager)
                .environmentObject(appLaunchViewModel)
                .environmentObject(permissionsViewModel)
                .environmentObject(cameraViewModel)
                .environmentObject(settingsViewModel)
                .preferredColorScheme(.dark)
        }
    }
}

