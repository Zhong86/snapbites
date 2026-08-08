
//
//  Apptheme.swift
//  SnapBites
//
//  Created by Mac on 07/08/26.
//
import SwiftUI

extension Color {
    /// Warm cream page background (#F6EFE7)
    static let appBackground = Color(red: 0xF6 / 255, green: 0xEF / 255, blue: 0xE7 / 255)
    /// Primary brand green (#01685C)
    static let primaryGreen = Color(red: 0x01 / 255, green: 0x68 / 255, blue: 0x5C / 255)
    /// Accent red for unsafe / alert states (#D7403F)
    static let accentRed = Color(red: 0xD7 / 255, green: 0x40 / 255, blue: 0x3F / 255)
    /// Secondary text color (#67605A)
    static let secondaryTextColor = Color(red: 0x67 / 255, green: 0x60 / 255, blue: 0x5A / 255)
    /// Filter / highlight accent (#CA9A46)
    static let filterAccent = Color(red: 0xCA / 255, green: 0x9A / 255, blue: 0x46 / 255)
    /// Card surface — always white regardless of the page background
    static let cardSurface = Color.white
    /// Subtle hairline stroke used on cards, pills, and toolbar buttons
    static let cardStroke = Color.black.opacity(0.06)
}

struct SummaryCardStyle: ViewModifier {
    var cornerRadius: CGFloat = 22
    var padding: CGFloat = 18

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.cardStroke, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

extension View {

    func summaryCard(cornerRadius: CGFloat = 22, padding: CGFloat = 18) -> some View {
        modifier(SummaryCardStyle(cornerRadius: cornerRadius, padding: padding))
    }
    
    func toolbarCircle() -> some View {
        self
            .frame(width: 44, height: 44)
            .background(Color.cardSurface)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.cardStroke, lineWidth: 1))
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
    }
}
