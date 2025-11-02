//
//  SettingsView.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Settings")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.white)
                        Text("CactusCamera")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    VStack(spacing: 20) {
                        SettingsSectionHeader(title: "Capture")

                        SettingsRowToggle(
                            title: "Auto Strobe Sync",
                            subtitle: "Flash reacts to music input",
                            isOn: $settingsViewModel.autoStrobeSync
                        )

                        SettingsRowToggle(
                            title: "Lock Exposure",
                            subtitle: "Keep brightness steady while recording",
                            isOn: $settingsViewModel.lockExposure
                        )

                        SettingsRowToggle(
                            title: "Save to Photos",
                            subtitle: "Automatically store videos in Library",
                            isOn: $settingsViewModel.autoSaveToPhotos
                        )
                    }
                    .padding(.horizontal, 20)

                    VStack(spacing: 20) {
                        SettingsSectionHeader(title: "Interface")

                        SettingsRowNavigation(
                            title: "Strobe Mode",
                            subtitle: settingsViewModel.strobeModeLabel
                        )

                        SettingsRowNavigation(
                            title: "Brand Overlay",
                            subtitle: settingsViewModel.brandOverlayEnabled ? "Enabled" : "Hidden"
                        )
                    }
                    .padding(.horizontal, 20)

                    VStack(spacing: 20) {
                        SettingsSectionHeader(title: "System")

                        SettingsRowNavigation(
                            title: "Audio Input Mode",
                            subtitle: settingsViewModel.audioInputModeLabel
                        )

                        SettingsRowNavigation(
                            title: "Permissions",
                            subtitle: "Camera • Mic • Photos"
                        )

                        SettingsRowNavigation(
                            title: "About",
                            subtitle: settingsViewModel.versionLabel
                        )
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                        .frame(height: 140)
                }
            }
        }
    }
}

struct SettingsSectionHeader: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SettingsRowToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.white)
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.gray)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.05))
        )
    }
}

struct SettingsRowNavigation: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.white)
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.05))
        )
    }
}
