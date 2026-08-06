//
//  TabBar.swift
//  SnapBites
//
//  Created by Mac on 04/08/26.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab: Tab = .summary

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.08)

        let selectedColor = UIColor(Color.primaryGreen)
        let normalColor = UIColor(Color.secondaryTextColor)

        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases) { tab in
                NavigationStack {
                    tab.destination
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.image)
                }
                .tag(tab)
            }
        }
        .tint(Color.primaryGreen)
    }
}

#Preview {
    TabBar()
}
