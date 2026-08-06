import SwiftUI
import SwiftData

struct SummaryChecklistView: View {
    @Bindable var ingredient: Ingredient
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private var sortedCauses: [PossibleCauses] {
        ingredient.possibleCauses.sorted { lhs, rhs in
            let lhsIsNonCause = lhs.status == "non_cause"
            let rhsIsNonCause = rhs.status == "non_cause"
            if lhsIsNonCause != rhsIsNonCause {
                return !lhsIsNonCause // non_cause sorts after everything else
            }
            return lhs.symptom?.name ?? "" < rhs.symptom?.name ?? ""
        }
    }
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(sortedCauses, id: \.persistentModelID) { cause in
                    if let symptom = cause.symptom {
                        Button {
                            toggle(cause)
                        } label: {
                            HStack {
                                Image(systemName: cause.status == "non_cause" ? "circle" : "checkmark.circle.fill")
                                    .foregroundStyle(cause.status == "non_cause" ? .gray : .green)
                                Text(symptom.name)
                                    .foregroundStyle(cause.status == "non_cause" ? .secondary : .primary)
                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .animation(.default, value: sortedCauses.map(\.status))
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // save logic here
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func toggle(_ cause: PossibleCauses) {
        let repo = PossibleCausesRepository(context: modelContext)
        if cause.status == "non_cause" {
            repo.markAsCause(cause)
        } else {
            repo.markAsNonCause(cause)
        }
    }
}
