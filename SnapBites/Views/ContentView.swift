//
//  ContentView.swift
//  SnapBites
//
//  Created by Mac on 22/07/26.
//

import SwiftUI
import SwiftData

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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Ingredient.self, Symtomp.self, PossibleCauses.self,
        configurations: config
    )
    let context = container.mainContext
    
    let ingredientRepo = IngredientRepository(context: context)
    let symptomRepo = SymptomRepository(context: context)
    let causeRepo = PossibleCausesRepository(context: context)
    
    // Ingredient with an active cause link -> should show in Summary
    let peanut = ingredientRepo.create(name: "kacang")
    let itchySkin = symptomRepo.create(name: "kulit gatel", imageName: "images")
    let hives = symptomRepo.create(name: "biduran", imageName: "biduran")
    _ = causeRepo.create(ingredient: peanut, symptom: itchySkin, status: "cause")
    _ = causeRepo.create(ingredient: peanut, symptom: hives, status: "unchecked")
    
    // Ingredient with a non_cause link -> still has a possibleCauses entry, still shows (option B: presence, not status)
    let shrimp = ingredientRepo.create(name: "udang")
    let rash = symptomRepo.create(name: "mata merah", imageName: "mata merah")
    _ = causeRepo.create(ingredient: shrimp, symptom: rash, status: "non_cause")
    
    // Ingredient with mixed statuses
    let milk = ingredientRepo.create(name: "susu")
    let bloating = symptomRepo.create(name: "kram perut", imageName: "kram perut")
    let nausea = symptomRepo.create(name: "mual", imageName: "mual")
    _ = causeRepo.create(ingredient: milk, symptom: bloating, status: "cause")
    _ = causeRepo.create(ingredient: milk, symptom: nausea, status: "non_cause")
    
    // Ingredient with NO possibleCauses at all -> should NOT show in Summary
    _ = ingredientRepo.create(name: "nasi")
    
    return ContentView()
        .modelContainer(container)
}
