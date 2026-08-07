import SwiftUI
import SwiftData

struct DebugView: View {
    @Query private var ingredients: [Ingredient]
    @Query private var symptoms: [Symtomp]
    @Query private var causes: [PossibleCauses]

    var body: some View {
        List {
            Section("Ingredients") {
                ForEach(ingredients) { i in
                    Text("\(i.name) - checked: \(i.hasChecked.description)")
                }
            }
            Section("Symptoms") {
                ForEach(symptoms) { s in
                    Text(s.name)
                }
            }
            Section("Possible Causes") {
                ForEach(causes) { c in
                    Text("\(c.ingredient?.name ?? "nil") → \(c.symptom?.name ?? "nil") : \(c.status)")
                }
            }
        }
    }
}

#Preview {
    DebugView()
}
