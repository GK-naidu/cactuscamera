//
//  RecordButtonView.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import SwiftUI

struct RecordButtonView: View {
    @Binding var isRecording: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .strokeBorder(Color.white, lineWidth: 3)
                    .frame(width: 78, height: 78)

                Circle()
                    .fill(isRecording ? Color.red : Color.white)
                    .frame(width: 56, height: 56)
            }
        }
        .buttonStyle(.plain)
    }
}
