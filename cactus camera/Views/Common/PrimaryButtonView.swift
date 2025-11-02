//
//  PrimaryButtonView.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI

struct PrimaryButtonView: View {
    let title: String
    let action: () -> Void
    var fill: Color = Color.white
    var foreground: Color = Color.black

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(foreground)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(fill)
                )
        }
        .buttonStyle(.plain)
    }
}
