//
//  SnapBitesApp.swift
//  SnapBites
//
//  Created by Mac on 22/07/26.
//

import SwiftUI
import SwiftData

@main
struct SnapBitesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Ingredient.self, Symtomp.self, PossibleCauses.self])
    }
}
