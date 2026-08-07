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
        case .summary: return "Overview"
        case .log: return "Journal"
        }
    }
    
    // SF Symbols icon names
    var image: String {
        switch self {
        case .summary: return "syringe"
        case .log: return "books.vertical"
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
