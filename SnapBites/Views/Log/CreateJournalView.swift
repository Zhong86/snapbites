import SwiftUI
import SwiftData

struct CreateJournalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var entryType: JournalEntryType = .ingredient
    @State private var ingredientNames: [String] = [""]
    @State private var selectedSymptom: Symtomp?
    @State private var entryDate: Date = Date()
    
    @State private var showCauseFoundAlert = false
    @State private var foundCauseNames: [String] = []
    
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
            .alert("Cause Found", isPresented: $showCauseFoundAlert) {
                Button("OK") { dismiss() }
            } message: {
                Text("A likely cause was already identified: \(foundCauseNames.joined(separator: ", ")).")
            }
        }
    }
    
    private func save() {
        switch entryType {
        case .ingredient:
            Task {
                let repository = IngredientRepository(context: modelContext)
                for name in ingredientNames {
                    let trimmed = name.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { continue }
                    _ = await repository.createOrUpdate(name: trimmed, timeUpdated: entryDate)
                }
                
                dismiss()
            }
        case .symptom:
            guard let selectedSymptom else { return }
            let updatedSymptom: Symtomp = SymptomRepository(context: modelContext).updateDate(selectedSymptom, date: entryDate)
            let (causeFound, causes) = SymptomCheckService().newSymptom(symptom: updatedSymptom, modelContext: modelContext)
            
            if causeFound {
                // A cause was already known — surface it via alert instead of
                // creating new PossibleCauses, and dismiss once the user acknowledges.
                foundCauseNames = causes.map(\.name)
                showCauseFoundAlert = true
            } else {
                // PossibleCauses were just created (inside newSymptom) for each
                // candidate ingredient — safe to close the sheet now.
                dismiss()
            }
        }
    }
}

#Preview {
    CreateJournalView()
}
