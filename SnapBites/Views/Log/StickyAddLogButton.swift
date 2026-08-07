//
//  StickyAddButton.swift
//  SnapBites
//
//  Created by Mac on 07/08/26.
//

import SwiftUI

struct StickyAddLogButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .foregroundStyle(.white)
                .padding(16)
                .background(Color.primaryGreen)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.primaryGreen.opacity(0.30), radius: 12, x: 0, y: 6)
        }
    }
}

#Preview {
    StickyAddLogButton(action: {})
        .padding()
        .background(Color.appBackground)
}
