import SwiftUI
import SwiftData

struct CreateJournalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var entryType: JournalEntryType = .ingredient
    @State private var ingredientNames: [String] = [""]
    @State private var selectedSymptom: Symtomp?
    @State private var entryDate: Date = Date()

    private var isSaveEnabled: Bool {
        switch entryType {
        case .ingredient:
            return ingredientNames.contains { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        case .symptom:
            return selectedSymptom != nil
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - Ingredient / Symptom toggle
                    JournalTypePicker(selection: $entryType)

                    // MARK: - Type-specific form
                    switch entryType {
                    case .ingredient:
                        IngredientListEditor(ingredientNames: $ingredientNames)
                    case .symptom:
                        SymptomPickerDropdown(selectedSymptom: $selectedSymptom)
                    }

                    // MARK: - Unified date/time field (shared by both types)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Time")
                            .font(.system(size: 14, weight: .bold))

                        DatePicker(
                            "",
                            selection: $entryDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                    }
                }
                .padding()
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!isSaveEnabled)
                }
            }
        }
    }

    private func save() {
        switch entryType {
        case .ingredient:
            let repository = IngredientRepository(context: modelContext)
            for name in ingredientNames {
                let trimmed = name.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else { continue }
                let ingredient = repository.create(name: trimmed, timeUpdated: entryDate)
            }

        case .symptom:
            guard let selectedSymptom else { return }
            let updatedSymptom: Symtomp = SymptomRepository(context: modelContext).updateDate(selectedSymptom, date: entryDate)
            SymptomCheckService().newSymptom(symptom: updatedSymptom, modelContext: modelContext)
        }

        dismiss()
    }
}

#Preview {
    CreateJournalView()
}
