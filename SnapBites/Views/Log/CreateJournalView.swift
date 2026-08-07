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
            ZStack {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // MARK: - Ingredient / Symptom toggle
                        JournalTypePicker(selection: $entryType)

                        // MARK: - Type-specific form
                        sectionCard {
                            switch entryType {
                            case .ingredient:
                                IngredientListEditor(ingredientNames: $ingredientNames)
                            case .symptom:
                                SymptomPickerDropdown(selectedSymptom: $selectedSymptom)
                            }
                        }

                        // MARK: - Unified date/time field (shared by both types)
                        sectionCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Time")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color.secondaryTextColor)

                                DatePicker(
                                    "",
                                    selection: $entryDate,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .labelsHidden()
                                .datePickerStyle(.compact)
                                .tint(Color.primaryGreen)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.secondaryTextColor)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.cardSurface)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.cardStroke, lineWidth: 1))
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save()
                    } label: {
                        Text("Save")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 8)
                            .background(isSaveEnabled ? Color.primaryGreen : Color.primaryGreen.opacity(0.4))
                            .clipShape(Capsule())
                    }
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

    /// Shared rounded white card used to group each form section.
    @ViewBuilder
    private func sectionCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding(18)
        .background(Color.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.cardStroke, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }

    private func save() {
        switch entryType {
        case .ingredient:
            let repository = IngredientRepository(context: modelContext)
            for name in ingredientNames {
                let trimmed = name.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else { continue }
                // Existing ingredient of the same name just gets its timeUpdated bumped
                // instead of creating a duplicate row.
                _ = repository.createOrUpdate(name: trimmed, timeUpdated: entryDate)
            }
            dismiss()

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
