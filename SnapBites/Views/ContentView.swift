//
//  ContentView.swift
//  SnapBites
//
//  Created by Mac on 22/07/26.
//

import SwiftUI

let dummy = Ingredient(name: "kacang", hasChecked: false)
let dummy2 = Symtomp(name: "biduran", imageName: "biduran")
let dummy3 = PossibleCauses(
    ingredient: dummy,
    symptom: dummy2,
    status: "cause",
    lastUpdated: .now
)

struct ContentView: View {
    var body: some View {
        VStack {
            TabBar()
        }
    }
}

#Preview {
    ContentView()
}
