//
//  TabBar.swift
//  SnapBites
//
//  Created by Mac on 04/08/26.
//

import SwiftUI



struct TabBar: View {
    @State private var selectedTab: Tab = .summary
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
        }.padding(4)

    }
}

#Preview {
    TabBar()
}
