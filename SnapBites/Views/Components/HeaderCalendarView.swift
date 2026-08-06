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
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color(UIColor.systemGray6))
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
                }

                Spacer()

                Text(monthTitle)
                    .font(.system(size: 18, weight: .bold))

                Spacer()

                Color.clear.frame(width: 40, height: 40) // Spacer to balance icon
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // Week Days — real dates, tappable to change selectedDate
            HStack {
                ForEach(weekDates, id: \.self) { date in
                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)

                    Spacer()

                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedDate = date
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text(date.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                                .font(.system(size: 12, weight: isSelected ? .bold : .regular))
                                .foregroundColor(isSelected ? .black : .gray)

                            Text(date.formatted(.dateTime.day()))
                                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                                .foregroundColor(isSelected ? .black : .gray)
                        }
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
            }
            .padding(.bottom, 10)

            Divider()
        }
    }
}

#Preview {
    HeaderCalendarView(selectedDate: .constant(Date()))
}
