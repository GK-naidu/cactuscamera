//
//  CameraView.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @EnvironmentObject var cameraViewModel: CameraViewModel
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                topBar
                    .padding(.top, 12)
                    .padding(.horizontal, 20)
                    .padding(.top, safeTopPadding())

                previewSection
                    .padding(.horizontal, 20)

                bottomControls
                    .padding(.horizontal, 40)

                Spacer()
                    .frame(height: 120)
            }
        }
        .onAppear {
            cameraViewModel.sessionManager.startSession()
        }
        .onDisappear {
            cameraViewModel.sessionManager.stopSession()
        }
    }

    private var topBar: some View {
        HStack {
            Text("CACTUS")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .kerning(0.5)
                .foregroundStyle(Color.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white.opacity(0.07))
                )

            Spacer()

            HStack(spacing: 12) {
                Button {
                } label: {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(width: 32, height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.white.opacity(0.07))
                        )
                }

                Button {
                } label: {
                    Text("1x")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(width: 44, height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.white.opacity(0.07))
                        )
                }

                Button {
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(width: 32, height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.white.opacity(0.07))
                        )
                }
            }
        }
    }

    private var previewSection: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.03))
                )
                .overlay(
                    CameraPreviewView(session: cameraViewModel.sessionManager.session)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                )
                .frame(maxWidth: .infinity)
                .frame(height: previewHeight())

            if case .saving = cameraViewModel.recordingState {
                savingBadge
                    .padding(.leading, 16)
                    .padding(.bottom, 16)
            } else if cameraViewModel.isRecording {
                recordingBadge
                    .padding(.leading, 16)
                    .padding(.bottom, 16)
            }
        }
    }

    private var recordingBadge: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)

            Text(cameraViewModel.elapsedDisplayText)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.white)

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.07))
        )
    }

    private var savingBadge: some View {
        HStack(spacing: 8) {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(Color.white)
                .frame(width: 14, height: 14)

            Text("Saving…")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.white)

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.07))
        )
    }

    private var bottomControls: some View {
        HStack {
            StrobeModeToggleView(
                isOn: $cameraViewModel.isStrobeOn,
                onToggle: { newValue in
                    cameraViewModel.setStrobeEnabled(newValue)
                }
            )

            Spacer()

            RecordButtonView(
                isRecording: Binding(
                    get: { cameraViewModel.isRecording },
                    set: { _ in }
                ),
                action: {
                    if case .saving = cameraViewModel.recordingState {
                        return
                    }
                    Haptics.strong()
                    cameraViewModel.toggleRecording()
                }
            )

            Spacer()

            Button {
                navigationManager.currentTab = .gallery
            } label: {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.white)
                    )
            }
        }
    }

    private func previewHeight() -> CGFloat {
        let screenH = UIScreen.main.bounds.height
        let reservedTop = safeTopPadding() + 80
        let reservedBottom: CGFloat = 240
        let usable = screenH - reservedTop - reservedBottom
        return max(usable, 300)
    }

    private func safeTopPadding() -> CGFloat {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return 44
        }
        return window.safeAreaInsets.top + 8
    }
}


