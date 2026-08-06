import SwiftUI

struct TimelineSectionView: View {
    let timeframe: LogTimeframe
    let entries: [JournalEntry]

    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(timeframe.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(UIColor.systemGray6).opacity(0.5))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                ForEach(entries) { entry in
                    TimelineRowView(entry: entry)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview {
    TimelineSectionView(
        timeframe: .morning,
        entries: [
            JournalEntry(time: "08:53", title: "Breakfast", subtitle: "Scrambled Egg", isSymptom: false, hour: 8)
        ]
    )
}
