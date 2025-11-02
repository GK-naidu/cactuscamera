//
//  GalleryView.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                header
                    .padding(.top, safeTopPadding())
                    .padding(.horizontal, 20)

                ScrollView {
                    if viewModel.assets.isEmpty {
                        emptyState
                            .padding(.top, 80)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 200)
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            ForEach(viewModel.assets) { asset in
                                GalleryThumbnailView(asset: asset)
                                    .onTapGesture {
                                        navigationManager.currentTab = .camera
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 160)
                        .padding(.top, 12)
                    }
                }
            }
        }
        .onAppear {
            viewModel.refresh()
        }
    }

    private var header: some View {
        HStack {
            Button {
                viewModel.refresh()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: 32, height: 32)
            }

            Spacer()

            HStack(spacing: 6) {
                Text("Gallery")
                    .font(.system(.headline, weight: .semibold))
                    .foregroundStyle(Color.white)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.white)
            }

            Spacer()

            Button {
            } label: {
                Text("Select")
                    .font(.system(.subheadline, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("No recent videos yet")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.white)

            Text("Your recordings will appear here after saving to Photos.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private func safeTopPadding() -> CGFloat {
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first
        else {
            return 44
        }
        return window.safeAreaInsets.top + 8
    }
}

struct GalleryThumbnailView: View {
    let asset: GalleryAsset

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = asset.thumbnail {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
            } else {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .frame(height: 180)
            }

            if asset.isVideo {
                HStack(spacing: 6) {
                    Image(systemName: "video.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.white)

                    if let duration = asset.durationText {
                        Text(duration)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.white)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.black.opacity(0.5))
                )
                .padding(.leading, 10)
                .padding(.bottom, 10)
            }
        }
    }
}
