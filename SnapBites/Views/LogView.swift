import SwiftUI

struct LogItem: Identifiable {
    let id = UUID()
    let timestamp: Date
    let title: String
}

struct LogView: View {
    // 1. Apple handles the date picker storage state automatically
    @State private var selectedDate = Date()
    
    @State private var allLogs: [LogItem] = [
        LogItem(timestamp: Date(), title: "gatel gatel"),
        LogItem(timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, title: "Makan Bebek")
    ]
    
    // 2. Simple clean database array filter loop
    private var filteredLogs: [LogItem] {
        allLogs.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDate) }
    }

    var body: some View {
        NavigationStack {
            List {
                // 3. Compact Picker: Combines title view and action control in one row
                DatePicker("Tanggal:", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .fontWeight(.medium)
                    .padding(.vertical, 4)
                
                // 4. Output list contents matching chosen calendar field
                if filteredLogs.isEmpty {
                    Text("No records captured on this day.")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                } else {
                    ForEach(filteredLogs) { log in
                        Text(log.title)
                    }
                }
            }
            .navigationTitle("Logs")
        }
    }
}

