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
            ZStack {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if !uncheckedCauses.isEmpty {
                            sectionCard(title: "To Review") {
                                VStack(spacing: 14) {
                                    ForEach(uncheckedCauses, id: \.persistentModelID) { cause in
                                        if let symptom = cause.symptom {
                                            HStack {
                                                Text(symptom.name)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundStyle(.black)

                                                Spacer()

                                                Button {
                                                    markSafe(cause)
                                                } label: {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .font(.system(size: 22))
                                                        .foregroundStyle(Color.primaryGreen)
                                                }

                                                Button {
                                                    markUnsafe(cause)
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .font(.system(size: 22))
                                                        .foregroundStyle(Color.accentRed)
                                                }
                                            }
                                            .padding(.vertical, 4)

                                            if symptom.name != uncheckedCauses.last?.symptom?.name {
                                                Divider()
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        if !unsafeCauses.isEmpty {
                            sectionCard(title: "Unsafe") {
                                VStack(spacing: 14) {
                                    ForEach(unsafeCauses, id: \.persistentModelID) { cause in
                                        causeRow(cause, statusColor: Color.accentRed, statusIcon: "exclamationmark.circle.fill")
                                        if cause.persistentModelID != unsafeCauses.last?.persistentModelID {
                                            Divider()
                                        }
                                    }
                                }
                            }
                        }

                        if !safeCauses.isEmpty {
                            sectionCard(title: "Safe") {
                                VStack(spacing: 14) {
                                    ForEach(safeCauses, id: \.persistentModelID) { cause in
                                        causeRow(cause, statusColor: Color.primaryGreen, statusIcon: "checkmark.circle.fill")
                                        if cause.persistentModelID != safeCauses.last?.persistentModelID {
                                            Divider()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
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
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.black)
                            .toolbarCircle()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.secondaryTextColor)

            content()
        }
        .summaryCard()
    }

    @ViewBuilder
    private func causeRow(_ cause: PossibleCauses, statusColor: Color, statusIcon: String) -> some View {
        if let symptom = cause.symptom {
            HStack {
                Image(systemName: statusIcon)
                    .foregroundStyle(statusColor)
                Text(symptom.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black)
                Spacer()
                Button {
                    revert(cause)
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.secondaryTextColor)
                }
            }
            .padding(.vertical, 4)
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
