import SwiftUI

struct LogView: View {
    // Tracks the selected date on the calendar matrix
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Native Calendar Header Title
            HStack {
                Text("Calendar")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            .padding(.horizontal)
            
            // MARK: - Native Month Grid Engine
            //  CORRECT
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: [.date]
            ) // <- Parenthesis must close here!
            .datePickerStyle(.graphical)
            .accentColor(.blue)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
    
}
