import SwiftUI

enum JournalEntryType: String, CaseIterable, Identifiable {
    case ingredient = "Ingredient"
    case symptom = "Symptom"

    var id: String { rawValue }
}

struct JournalTypePicker: View {
    @Binding var selection: JournalEntryType

    var body: some View {
        HStack(spacing: 4) {
            ForEach(JournalEntryType.allCases) { type in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = type
                    }
                } label: {
                    Text(type.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(selection == type ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(selection == type ? Color.primaryGreen : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            Capsule().fill(Color.cardSurface)
        )
        .overlay(
            Capsule().stroke(Color.cardStroke, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    JournalTypePicker(selection: .constant(.ingredient))
        .padding()
        .background(Color.appBackground)
}
