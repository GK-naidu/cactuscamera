//
//  PermissionsView.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI
import AVFoundation

struct PermissionsView: View {
    @EnvironmentObject var permissionsViewModel: PermissionsViewModel
    @EnvironmentObject var appLaunchViewModel: AppLaunchViewModel

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
                    permissionsViewModel.requestAll { _ in
                        appLaunchViewModel.refreshPermissions()
                    }
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

struct PermissionRowView: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.07))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.white)

                Text(detail)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.gray)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.05))
        )
    }
}
