import SwiftUI
import SwiftData

struct SummaryChecklistView: View {
    @Bindable var ingredient: Ingredient
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private var uncheckedCauses: [PossibleCauses] {
        ingredient.possibleCauses
            .filter { $0.status == "unchecked" }
            .sorted { $0.symptom?.name ?? "" < $1.symptom?.name ?? "" }
    }

    private var unsafeCauses: [PossibleCauses] {
        ingredient.possibleCauses
            .filter { $0.status == "cause" }
            .sorted { $0.symptom?.name ?? "" < $1.symptom?.name ?? "" }
    }

    private var safeCauses: [PossibleCauses] {
        ingredient.possibleCauses
            .filter { $0.status == "non_cause" }
            .sorted { $0.symptom?.name ?? "" < $1.symptom?.name ?? "" }
    }

    var body: some View {
        NavigationStack {
            List {
                if !uncheckedCauses.isEmpty {
                    Section("To Review") {
                        ForEach(uncheckedCauses, id: \.persistentModelID) { cause in
                            if let symptom = cause.symptom {
                                HStack {
                                    Text(symptom.name)
                                    Spacer()
                                    Button {
                                        markSafe(cause)
                                    } label: {
                                        Label("Safe", systemImage: "checkmark.circle")
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.green)

                                    Button {
                                        markUnsafe(cause)
                                    } label: {
                                        Label("Unsafe", systemImage: "xmark.circle")
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.red)
                                }
                                .labelStyle(.iconOnly)
                            }
                        }
                    }
                }

                if !unsafeCauses.isEmpty {
                    Section("Unsafe") {
                        ForEach(unsafeCauses, id: \.persistentModelID) { cause in
                            causeRow(cause, statusColor: .red, statusIcon: "exclamationmark.circle.fill")
                        }
                    }
                }

                if !safeCauses.isEmpty {
                    Section("Safe") {
                        ForEach(safeCauses, id: \.persistentModelID) { cause in
                            causeRow(cause, statusColor: .green, statusIcon: "checkmark.circle.fill")
                        }
                    }
                }
            }
            .animation(.default, value: ingredient.possibleCauses.map(\.status))
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func causeRow(_ cause: PossibleCauses, statusColor: Color, statusIcon: String) -> some View {
        if let symptom = cause.symptom {
            HStack {
                Image(systemName: statusIcon)
                    .foregroundStyle(statusColor)
                Text(symptom.name)
                Spacer()
                Button {
                    revert(cause)
                } label: {
                    Label("Revert", systemImage: "arrow.uturn.backward")
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func markSafe(_ cause: PossibleCauses) {
        PossibleCausesRepository(context: modelContext).markAsNonCause(cause)
    }

    private func markUnsafe(_ cause: PossibleCauses) {
        PossibleCausesRepository(context: modelContext).markAsCause(cause)
    }

    private func revert(_ cause: PossibleCauses) {
        PossibleCausesRepository(context: modelContext).reset(cause)
    }
}
