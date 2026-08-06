import SwiftUI
import SwiftData
import EventKit
import Observation

struct LogView: View {
    // Keeping your SwiftData environment ready!
    @Environment(\.modelContext) private var modelContext

    @State private var showModal = false
    @State private var selectedDate = Date()

    // Dummy Data matching your screenshot (hour drives timeframe bucketing)
    let entries = [
        JournalEntry(time: "08:53", title: "Breakfast", subtitle: "Scrumble Egg", isSymptom: false, hour: 8),
        JournalEntry(time: "08:54", title: "Bloating", subtitle: "fever", isSymptom: true, hour: 8),
        JournalEntry(time: "08:55", title: "Breakfast", subtitle: "Udang", isSymptom: false, hour: 8),
        JournalEntry(time: "13:15", title: "Lunch", subtitle: "Chamomile Tea", isSymptom: false, hour: 13),
        JournalEntry(time: "14:20", title: "Bloating", subtitle: "gatal", isSymptom: true, hour: 14),
        JournalEntry(time: "19:40", title: "Dinner", subtitle: "Nasi Goreng", isSymptom: false, hour: 19)
    ]

    private var groupedEntries: [LogTimeframe: [JournalEntry]] {
        Dictionary(grouping: entries, by: \.timeframe)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                // --- TOP CALENDAR SECTION ---
                HeaderCalendarView(selectedDate: $selectedDate)

                // --- TIMELINE SECTION ---
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(LogTimeframe.allCases) { timeframe in
                            let sectionEntries = groupedEntries[timeframe] ?? []
                            if !sectionEntries.isEmpty {
                                TimelineSectionView(timeframe: timeframe, entries: sectionEntries)
                            }
                        }
                    }
                    // Leave room so content can scroll clear of the sticky button
                    .padding(.bottom, 90)
                }
            }
            .background(Color.white)

            StickyAddLogButton {
                showModal.toggle()
            }
            .padding(.trailing, 20)
        }
        .sheet(isPresented: $showModal) {
            CreateLogView()
        }
    }
}

#Preview {
    LogView()
}
