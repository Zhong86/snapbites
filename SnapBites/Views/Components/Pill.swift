//
//  Pill.swift
//  SnapBites
//
//  Created by Mac on 06/08/26.
//
import SwiftUI

struct Pill: View {
    @State var text: String
    var borderColor: Color = .black
    
    var body: some View {
        Text(text)
            .padding(4)
            .font(.caption)
            .clipShape(RoundedRectangle(cornerRadius: 50))
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(borderColor, lineWidth: 1)
            )
            .shadow(radius: 5)
    }
}
