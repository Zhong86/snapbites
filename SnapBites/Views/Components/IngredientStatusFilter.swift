//
//  IngredientStatusFilter.swift
//  SnapBites
//
//  Created by Mac on 08/08/26.
//

import SwiftUI

enum IngredientStatusFilter: CaseIterable, Identifiable {
    case all
    case safe
    case unsafe
    case unchecked

    var id: Self { self }

    var label: String {
        switch self {
        case .all: return "All"
        case .safe: return "✓ Safe"
        case .unsafe: return "✕ Unsafe"
        case .unchecked: return "? Unchecked"
        }
    }
}

/// Horizontal, capsule-style segmented filter control.
///
/// Purely presentational: it just reports the tapped option back via a
/// binding. It does not know about `Ingredient` or `PossibleCauses` at all,
/// so it can be reused anywhere a status filter is needed later (e.g. the
/// Summary list screen) with zero changes.
struct IngredientStatusFilterBar: View {
    @Binding var selectedFilter: IngredientStatusFilter

    var body: some View {
        HStack(spacing: 8) {
            ForEach(IngredientStatusFilter.allCases) { filter in
                filterChip(for: filter)
            }
        }
    }

    @ViewBuilder
    private func filterChip(for filter: IngredientStatusFilter) -> some View {
        let isSelected = selectedFilter == filter

        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedFilter = filter
            }
        } label: {
            Text(filter.label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(isSelected ? .white : .black)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.primaryGreen : Color.cardSurface)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.cardStroke, lineWidth: 1)
                )
                .shadow(
                    color: .black.opacity(isSelected ? 0 : 0.06),
                    radius: isSelected ? 0 : 6,
                    x: 0,
                    y: isSelected ? 0 : 2
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    StatefulPreviewWrapper(.all) { selection in
        IngredientStatusFilterBar(selectedFilter: selection)
            .padding()
            .background(Color.appBackground)
    }
}

/// Small helper so the #Preview above can hold @State for the binding.
private struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ initial: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: initial)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
