import SwiftUI

enum JournalEntryType: String, CaseIterable, Identifiable {
    case ingredient = "Ingredient"
    case symptom = "Symptom"

    var id: String { rawValue }
}

struct JournalTypePicker: View {
    @Binding var selection: JournalEntryType

    var body: some View {
        Picker("Type", selection: $selection) {
            ForEach(JournalEntryType.allCases) { type in
                Text(type.rawValue).tag(type)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    JournalTypePicker(selection: .constant(.ingredient))
        .padding()
}
