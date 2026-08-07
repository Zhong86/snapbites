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
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                // --- TIMELINE SECTION ---
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(LogTimeframe.allCases) { timeframe in
                            let sectionEntries = groupedEntries[timeframe] ?? []
                            if !sectionEntries.isEmpty {
                                TimelineSectionView(timeframe: timeframe, entries: sectionEntries)
                                    .background(Color.cardSurface)
                                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                                            .stroke(Color.cardStroke, lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    // Leave room so content can scroll clear of the sticky button
                    .padding(.bottom, 100)
                }
            }
            .background(Color.appBackground)

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
