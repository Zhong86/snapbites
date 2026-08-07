//
//  Pill.swift
//  SnapBites
//
//  Created by Mac on 06/08/26.
//
import SwiftUI

struct Pill: View {
    @State var text: String
    var borderColor: Color = .primaryGreen

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(borderColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(borderColor.opacity(0.10))
            )
            .overlay(
                Capsule()
                    .stroke(borderColor.opacity(0.4), lineWidth: 1)
            )
    }
}

#Preview {
    HStack {
        Pill(text: "Peanuts", borderColor: .accentRed)
        Pill(text: "Reviewed", borderColor: .primaryGreen)
    }
    .padding()
    .background(Color.appBackground)
}
