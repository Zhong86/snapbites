import SwiftUI
import SwiftData
import EventKit
import Observation

struct LogView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var entries: [JournalEntry] = []
    @State private var showModal = false
    @State private var selectedDate = Date()

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
            CreateJournalView()
        }
        .task {
            let ingredientRepo = IngredientRepository(context: modelContext)
            let symptomRepo = SymptomRepository(context: modelContext)

            let service = JournalService(
                ingredientRepository: ingredientRepo,
                symptomRepository: symptomRepo
            )
            entries = service.getJournal(date: selectedDate)
        }
    }
}

#Preview {
    LogView()
}
