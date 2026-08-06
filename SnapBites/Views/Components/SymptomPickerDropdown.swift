import SwiftUI

struct SymptomPickerDropdown: View {
    @Binding var selectedSymptom: Symtomp?

    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(selectedSymptom?.name ?? "Select a symptom")
                        .foregroundStyle(selectedSymptom == nil ? Color.secondaryTextColor : .black)
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundStyle(Color.primaryGreen)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(Color.cardSurface)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.cardStroke, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
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
                                .font(.system(size: 15, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 14)
                                .foregroundStyle(.black)
                                .background(
                                    selectedSymptom?.name == symptom.name
                                        ? Color.primaryGreen.opacity(0.08)
                                        : Color.clear
                                )
                        }
                        .buttonStyle(.plain)

                        if symptom.name != symptoms.last?.name {
                            Divider()
                                .padding(.leading, 18)
                        }
                    }
                }
                .background(Color.cardSurface)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.cardStroke, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview {
    SymptomPickerDropdown(selectedSymptom: .constant(nil))
        .padding()
        .background(Color.appBackground)
}
