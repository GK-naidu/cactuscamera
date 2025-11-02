//
//  StrobeSafetyWarningView.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI

struct StrobeSafetyWarningView: View {
    let onAcknowledge: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("Flash Intensity Warning")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.white)

                    Text("CactusCamera can fire rapid high-intensity flash pulses while recording. Avoid pointing directly at faces or eyes. Stop immediately if you experience discomfort, dizziness, or visual disturbance.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                VStack(alignment: .leading, spacing: 16) {
                    StrobeBulletRow(
                        icon: "bolt.fill",
                        title: "Rapid Pulses",
                        desc: "The flash may strobe on beat with music and repeat frequently."
                    )

                    StrobeBulletRow(
                        icon: "eye.trianglebadge.exclamationmark.fill",
                        title: "Avoid Eyes",
                        desc: "Do not aim directly at eyes or faces at close range."
                    )

                    StrobeBulletRow(
                        icon: "heart.text.square.fill",
                        title: "Sensitivity",
                        desc: "Individuals with photosensitive conditions may be at higher risk."
                    )
                }
                .padding(.horizontal, 20)

                Button(action: onAcknowledge) {
                    Text("I Understand")
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

struct StrobeBulletRow: View {
    let icon: String
    let title: String
    let desc: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.07))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.white)

                Text(desc)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.gray)
                    .fixedSize(horizontal: false, vertical: true)
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
