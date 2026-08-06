import SwiftUI
import SwiftData

struct AddSummaryView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var hasChecked: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Ingredient") {
                    TextField("Name", text: $name)
                }
            }
            .navigationTitle("Add Ingredient")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveIngredient()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveIngredient() {
        let newIngredient = Ingredient(
            name: name,
        )
        modelContext.insert(newIngredient)

        do {
            try modelContext.save()
        } catch {
            print("Failed to save ingredient: \(error)")
        }

        dismiss()
    }
}

#Preview {
    AddSummaryView()
        .modelContext(try! ModelContainer(for: Ingredient.self).mainContext)
}
