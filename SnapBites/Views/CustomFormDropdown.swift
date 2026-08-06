
import SwiftUI

enum SelectionOption: String, CaseIterable {
    case food = "Food"
    case symptom = "Symptom"
}

struct CustomFormDropdown: View {
    // Dropdown open/close state
    @State private var isExpanded: Bool = false
    @State private var selectedOption: SelectionOption? = nil
    
    // Form data fields
    @State private var ingredient: String = ""
    @State private var symptomText: String = ""
    @State private var description: String = ""
    @State private var selectedDate = Date()

    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Dropdown Header Button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedOption?.rawValue ?? "Select an option")
                        .foregroundColor(selectedOption == nil ? .gray : .black)
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
            
            // MARK: - Expanded Options Menu
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(SelectionOption.allCases, id: \.self) { option in
                        Button(action: {
                            withAnimation(.easeInOut) {
                                selectedOption = option
                                isExpanded = false // Close dropdown on select
                            }
                        }) {
                            Text(option.rawValue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .foregroundColor(.black)
                                .background(selectedOption == option ? Color(.systemGray6) : Color.clear)
                        }
                        
                        if option == .food { Divider() }
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
            
            // MARK: - Dynamic Form Fields Block
            if !isExpanded, let selection = selectedOption {
                VStack(alignment: .leading, spacing: 12) {
                    switch selection {
                    case .food:
                        customTextField(label: "Ingredient", text: $ingredient)
                        
                        // Add Button (+)
                        Button(action: {}) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        
                    case .symptom:
                        customTextField(label: "Symptom", text: $symptomText)
                        customTextField(label: "Deskripsi (opsional)", text: $description)
                    }
                    
                    // Footer Actions (Date Pickers and Save Button)
                    HStack {
                        DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                        
                        Spacer()
                        
                        Button("Save") {
                            // Handle your form submission here
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    .padding(.top, 8)
                }
                .transition(.opacity)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.4))
        .cornerRadius(12)
    }
    
    // Reusable custom layout helper for text fields
    @ViewBuilder
    private func customTextField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
            TextField("", text: text)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        }
    }
}
