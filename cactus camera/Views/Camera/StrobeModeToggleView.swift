//
//  StrobeModeToggleView.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI

struct StrobeModeToggleView: View {
    @Binding var isOn: Bool
    var onToggle: (Bool) -> Void

    var body: some View {
        ToggleButton(
            active: isOn,
            iconOn: "bolt.fill",
            iconOff: "bolt.slash.fill"
        ) {
            isOn.toggle()
            onToggle(isOn)
        }
    }
}

struct ToggleButton: View {
    let active: Bool
    let iconOn: String
    let iconOff: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: active ? iconOn : iconOff)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(active ? Color.yellow : Color.white)
                .frame(width: 56, height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.1))
                )
        }
        .buttonStyle(.plain)
    }
}



