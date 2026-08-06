import SwiftUI
import SwiftData
import EventKit
import Observation

// MARK: - 1. Dummy Data Model (Until SwiftData is connected)
struct JournalEntry: Identifiable {
    let id = UUID()
        let time: String
        let title: String
        let subtitle: String
        let isSymptom: Bool
        let imagePlaceholder: String?
}

// MARK: - 2. Main Log View
struct LogView: View {
    // Keeping your SwiftData environment ready!
    @Environment(\.modelContext) private var modelContext
        @State private var showModal = false


        // Dummy Data matching your screenshot
        let entries = [
        JournalEntry(time: "08:53", title: "Breakfast", subtitle: "Scrumble Egg", isSymptom: false, imagePlaceholder: nil),
        JournalEntry(time: "08:54", title: "Bloating", subtitle: "fever", isSymptom: true, imagePlaceholder: "person.crop.square.fill"),
        JournalEntry(time: "08:55", title: "Breakfast", subtitle: "Udang", isSymptom: false, imagePlaceholder: nil),
        JournalEntry(time: "08:55", title: "Breakfast", subtitle: "Chamomile Tea", isSymptom: false, imagePlaceholder: nil),
        JournalEntry(time: "10:20", title: "Bloating", subtitle: "gatal", isSymptom: true, imagePlaceholder: "hand.raised.square.fill")
        ]

        var body: some View {
            VStack(spacing: 0) {
                Button(action: {
                        showModal.toggle()
                        }) {
                    HStack {
                        Spacer ()
                            Image(systemName: "plus.circle")

                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.blue)
                            .frame(width: 40, height: 50)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.white)
                            .cornerRadius(50)

                    }
                }
                .sheet(isPresented: $showModal) {
                    CreateLogView()
                }
                Spacer ()

                    // --- TOP CALENDAR SECTION ---
                    HeaderCalendarView()

                    // --- TIMELINE SECTION ---
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {

                            // Section Header ("Morning")
                            HStack {
                                Text("Morning")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                            .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color(UIColor.systemGray6).opacity(0.5))

                                // Timeline List
                                ForEach(entries) { entry in
                                    TimelineRowView(entry: entry)
                                }
                        }
                    }
            }
            .background(Color.white)
        }
}

// MARK: - 3. UI Subcomponents

struct HeaderCalendarView: View {
    let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        let dates = ["26", "27", "28", "29", "30", "31", "1"]

        var body: some View {
            VStack(spacing: 16) {
                // Month Title & Icon
                HStack {
                    Button(action: {}) {
                        Image(systemName: "calendar")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color(UIColor.systemGray6))
                            .clipShape(Circle())
                    }

                    Spacer()

                        Text("Jul 29")
                        .font(.system(size: 18, weight: .bold))

                        Spacer()

                        Color.clear.frame(width: 40, height: 40) // Spacer to balance icon
                }
                .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // Week Days
                    HStack {
                        ForEach(0..<7, id: \.self) { index in
                            Spacer()
                                VStack(spacing: 4) {
                                    Text(days[index])
                                        .font(.system(size: 12, weight: index == 3 ? .bold : .regular))
                                        .foregroundColor(index == 3 ? .black : .gray)

                                        Text(dates[index])
                                        .font(.system(size: 16, weight: index == 3 ? .bold : .regular))
                                        .foregroundColor(index == 3 ? .black : .gray)
                                }
                            Spacer()
                        }
                    }
                .padding(.bottom, 10)

                    Divider()
            }
        }
}

struct TimelineRowView: View {
    let entry: JournalEntry

        var body: some View {
            HStack(alignment: .top, spacing: 0) {

                // Left Side: Time
                Text(entry.time)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(width: 70, alignment: .center)
                    .padding(.top, 16)

                    // The Vertical Timeline Divider Line
                    Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 1)

                    // Right Side: Content
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(entry.title)
                                .font(.system(size: 16, weight: .regular))

                                if entry.isSymptom {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 8, height: 8)
                                }
                        }

                        Text(entry.subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .italic(entry.isSymptom)

                            if let image = entry.imagePlaceholder {
                                Image(systemName: image) // Replaced with your assets later
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .background(Color(UIColor.systemGray5))
                                    .cornerRadius(8)
                                    .foregroundColor(.gray)
                                    .padding(.top, 4)
                            }
                    }
                .padding(.vertical, 16)
                    .padding(.horizontal, 16)

                    Spacer()
            }
            .background(Color.white)
                .overlay(Divider(), alignment: .bottom)
        }
}
#Preview {
    LogView()
}
