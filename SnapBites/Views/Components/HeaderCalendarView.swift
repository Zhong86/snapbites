import SwiftUI

struct HeaderCalendarView: View {
    @Binding var selectedDate: Date

    @State private var showDatePicker = false

    private let calendar = Calendar.current

    /// The Sun–Sat week that contains `selectedDate`.
    private var weekDates: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else {
            return []
        }
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: weekInterval.start)
        }
    }

    private var monthTitle: String {
        selectedDate.formatted(.dateTime.month(.abbreviated).day())
    }

    var body: some View {
        VStack(spacing: 16) {
            // Month Title & Date Picker Button
            HStack {
                Button(action: { showDatePicker = true }) {
                    Image(systemName: "calendar")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.black)
                        .frame(width: 40, height: 40)
                        .background(Color.appBackground)
                        .clipShape(Circle())
                }
                .popover(isPresented: $showDatePicker) {
                    DatePicker(
                        "Select date",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding()
                    .frame(minWidth: 320, minHeight: 360)
                    .tint(Color.primaryGreen)
                }

                Spacer()

                Text(monthTitle)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)

                Spacer()

                Color.clear.frame(width: 40, height: 40) // Spacer to balance icon
            }
            .padding(.horizontal, 4)

            // Week Days — real dates, tappable to change selectedDate
            HStack {
                ForEach(weekDates, id: \.self) { date in
                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)

                    Spacer()

                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selectedDate = date
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Text(date.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                                .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                                .foregroundStyle(isSelected ? Color.primaryGreen : Color.secondaryTextColor)

                            Text(date.formatted(.dateTime.day()))
                                .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                                .foregroundStyle(isSelected ? .white : .black)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(isSelected ? Color.primaryGreen : Color.clear)
                                )
                        }
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
            }
        }
        .padding(18)
        .background(Color.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.cardStroke, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    HeaderCalendarView(selectedDate: .constant(Date()))
        .padding()
        .background(Color.appBackground)
}
