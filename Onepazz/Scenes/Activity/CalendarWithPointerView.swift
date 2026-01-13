//
//  CalendarWithPointerView.swift
//  Onepazz
//
//  Created by Claude on 10/26/25.
//

import SwiftUI

struct CalendarWithPointerView: View {
    @Binding var currentMonth: Date
    @Binding var selectedDate: Date

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: Spacing.l) {
                // Month Header
                Text(monthYearString(from: currentMonth))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Days of Week (Dynamic based on current week)
                HStack {
                    ForEach(getCurrentWeek(), id: \.self) { date in
                        Text(getDayOfWeekLabel(for: date))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? AppColor.textPrimary : AppColor.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                }

                // Calendar Days (Current Week Only)
                HStack(spacing: 0) {
                    ForEach(getCurrentWeek(), id: \.self) { date in
                        DayPointerCell(date: date, selectedDate: $selectedDate)
                            .frame(maxWidth: .infinity)
                    }
                }

                // Today Card with pointer
                VStack(spacing: 0) {
                    // Triangle pointer
                    Triangle()
                        .fill(Color.cyan.opacity(0.2))
                        .frame(width: 30, height: 15)

                    // Card content
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Today is")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(AppColor.textPrimary)
                        Text("Chest Day")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(AppColor.textPrimary)
                    }
                    .padding(Spacing.l)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.l, style: .continuous)
                            .fill(Color.cyan.opacity(0.2))
                    )
                }
            }
            .padding(Spacing.xl)
            .background(Color(.systemGray5))
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(Radius.l)
        .padding(.horizontal, Spacing.xl)
    }

    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }

    func getCurrentWeek() -> [Date] {
        let calendar = Calendar.current

        // Show 3 days before and 3 days after the selected date (7 days total with selected in middle)
        var week: [Date] = []
        for i in -3...3 {
            if let date = calendar.date(byAdding: .day, value: i, to: selectedDate) {
                week.append(date)
            }
        }

        return week
    }

    func getDayOfWeekLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE" // Single letter (M, T, W, etc.)
        let singleLetter = formatter.string(from: date)

        // Special case for Thursday
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        if weekday == 5 { // Thursday
            return "TH"
        }

        return singleLetter.uppercased()
    }
}

struct DayPointerCell: View {
    let date: Date
    @Binding var selectedDate: Date

    var isSelected: Bool {
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    var body: some View {
        Button {
            selectedDate = date
        } label: {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 18, weight: isSelected ? .bold : .regular))
                .foregroundStyle(isSelected ? .black : Color.gray)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isSelected ? Color.cyan.opacity(0.3) : Color.clear)
                )
        }
    }
}

// Triangle shape for pointer
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CalendarWithPointerView(currentMonth: .constant(Date()), selectedDate: .constant(Date()))
}
