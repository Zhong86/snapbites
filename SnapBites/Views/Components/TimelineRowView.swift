import SwiftUI

struct TimelineRowView: View {
    let entry: JournalEntry
    var onDelete: () -> Void = {}

    @State private var offsetX: CGFloat = 0
    private let deleteButtonWidth: CGFloat = 76

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer()
                Button(role: .destructive) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        offsetX = 0
                    }
                    onDelete()
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Delete")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.white)
                    .frame(width: deleteButtonWidth)
                    .frame(maxHeight: .infinity)
                }
                .background(Color.red)
            }

            rowContent
                .background(Color.white)
                .offset(x: offsetX)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translation = value.translation.width
                            if translation < 0 {
                                offsetX = max(translation, -deleteButtonWidth)
                            } else if offsetX < 0 {
                                offsetX = min(0, offsetX + translation)
                            }
                        }
                        .onEnded { value in
                            withAnimation(.easeOut(duration: 0.2)) {
                                offsetX = value.translation.width < -deleteButtonWidth / 2 ? -deleteButtonWidth : 0
                            }
                        }
                )
        }
        .clipped()
        .overlay(Divider(), alignment: .bottom)
    }

    private var rowContent: some View {
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
    }
}

#Preview {
    TimelineRowView(
        entry: JournalEntry(modelID: nil, time: "08:53", title: "Breakfast", subtitle: "Scrambled Egg", isSymptom: false, hour: 8)
    )
}
