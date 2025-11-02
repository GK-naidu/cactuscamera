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

            VStack {
                topBar
                    .padding(.top, 20)
                    .padding(.horizontal, 20)

                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            CameraPreviewView(session: cameraViewModel.sessionManager.session)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        )
                }
                .padding(.horizontal, 20)
                .aspectRatio(3/4, contentMode: .fit)

                bottomControls
                    .padding(.horizontal, 40)
                    .padding(.top, 20)

                Spacer()
                    .frame(height: 100)
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
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)

            Spacer()

            HStack(spacing: 12) {
                Button {} label: {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                }

                Button {} label: {
                    Text("1x")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 32)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                }

                Button {} label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
    }

    private var bottomControls: some View {
        HStack {
            Button {
                cameraViewModel.setStrobeEnabled(!cameraViewModel.isStrobeOn)
            } label: {
                Image(systemName: cameraViewModel.isStrobeOn ? "bolt.fill" : "bolt.slash.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
            }

            Spacer()

            Button {
                if case .saving = cameraViewModel.recordingState { return }
                Haptics.strong()
                cameraViewModel.toggleRecording()
            } label: {
                Circle()
                    .strokeBorder(Color.white, lineWidth: 4)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .fill(cameraViewModel.isRecording ? Color.red : Color.white)
                            .frame(width: 60, height: 60)
                    )
            }

            Spacer()

            Button {
                navigationManager.currentTab = .gallery
            } label: {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
            }
        }
    }
}
