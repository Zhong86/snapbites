//
//  Tab.swift
//  SnapBites
//
//  Created by Mac on 04/08/27.
//
import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    case summary = "Summary"
    case log = "Log"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .summary: return "Home"
        case .log: return "Logs"
        }
    }
    
    // SF Symbols icon names
    var image: String {
        switch self {
        case .summary: return "globe"
        case .log: return "globe"
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .summary:
            SummaryView()
        case .log:
            LogView()
        }
    }
}
