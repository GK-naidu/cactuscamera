//
//  RootView.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var appLaunchViewModel: AppLaunchViewModel
    @EnvironmentObject var permissionsViewModel: PermissionsViewModel
    @EnvironmentObject var cameraViewModel: CameraViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if appLaunchViewModel.shouldShowPermissionsGate || !permissionsViewModel.allGranted {
                    PermissionsGateView()
                } else {
                    switch navigationManager.currentTab {
                    case .gallery:
                        GalleryView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                    case .camera:
                        CameraView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                    case .settings:
                        SettingsView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                    }
                }
            }

            if !(appLaunchViewModel.shouldShowPermissionsGate || !permissionsViewModel.allGranted) {
                FloatingTabBarView(selection: $navigationManager.currentTab)
                    .padding(.bottom, 32)
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}

private struct PermissionsGateView: View {
    @EnvironmentObject var permissionsViewModel: PermissionsViewModel
    @EnvironmentObject var appLaunchViewModel: AppLaunchViewModel

    var body: some View {
        PermissionsViewContent(
            requestAction: {
                permissionsViewModel.requestAll { _ in
                    appLaunchViewModel.refreshPermissions()
                }
            }
        )
    }
}

private struct PermissionsViewContent: View {
    let requestAction: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("Permissions Required")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.white)

                    Text("To record video with reactive strobe, CactusCamera needs access to your camera, microphone and photo library.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                VStack(spacing: 16) {
                    PermissionRowView(
                        icon: "camera.fill",
                        title: "Camera",
                        detail: "Record video and capture photos"
                    )

                    PermissionRowView(
                        icon: "mic.fill",
                        title: "Microphone",
                        detail: "Sync flash with live audio"
                    )

                    PermissionRowView(
                        icon: "photo.on.rectangle.angled",
                        title: "Photos",
                        detail: "Save your recordings"
                    )
                }
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Strobe Warning")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("The flash may pulse rapidly during recording. Do not point directly at eyes. Stop use if you feel discomfort.")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)

                Button(action: {
                    requestAction()
                }) {
                    Text("Enable Access")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                        )
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding(.top, 60)
        }
    }
}

struct FloatingTabBarView: View {
    @Binding var selection: AppTab

    var body: some View {
        HStack(spacing: 24) {
            TabButton(
                isActive: selection == .gallery,
                action: { selection = .gallery },
                systemName: "list.bullet"
            )

            TabButton(
                isActive: selection == .camera,
                action: { selection = .camera },
                systemName: "viewfinder"
            )

            TabButton(
                isActive: selection == .settings,
                action: { selection = .settings },
                systemName: "gearshape"
            )
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
        )
    }
}

struct TabButton: View {
    var isActive: Bool
    var action: () -> Void
    var systemName: String

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(isActive ? Color.white : Color.gray)
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.plain)
    }
}
