import SwiftUI

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
    TimelineRowView(
        entry: JournalEntry(time: "08:53", title: "Breakfast", subtitle: "Scrambled Egg", isSymptom: false, hour: 8)
    )
}
