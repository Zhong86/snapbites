import SwiftUI

struct SymptomPickerDropdown: View {
    @Binding var selectedSymptom: Symtomp?

    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(selectedSymptom?.name ?? "Select a symptom")
                        .foregroundColor(selectedSymptom == nil ? .gray : .black)
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(symptoms, id: \.name) { symptom in
                        Button {
                            withAnimation(.easeInOut) {
                                selectedSymptom = symptom
                                isExpanded = false
                            }
                        } label: {
                            Text(symptom.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .foregroundColor(.black)
                                .background(
                                    selectedSymptom?.name == symptom.name
                                        ? Color(.systemGray6)
                                        : Color.clear
                                )
                        }
                        .buttonStyle(.plain)

                        if symptom.name != symptoms.last?.name {
                            Divider()
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview {
    SymptomPickerDropdown(selectedSymptom: .constant(nil))
        .padding()
}
