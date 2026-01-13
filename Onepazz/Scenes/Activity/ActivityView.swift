//
//  ActivityView.swift
//  Onepazz
//
//  Created by Claude on 10/26/25.
//

import SwiftUI

struct ActivityView: View {
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // Calendar with Pointer (new design)
                CalendarWithPointerView(currentMonth: $currentMonth, selectedDate: $selectedDate)

                // To switch back to old calendar, replace the line above with:
                // CalendarView(currentMonth: $currentMonth, selectedDate: $selectedDate)
                //     .padding(.horizontal, Spacing.xl)
                //
                // Text("Today is\nChest Day")
                //     .appFont(.title3)
                //     .foregroundStyle(AppColor.textPrimary)
                //     .padding(Spacing.l)
                //     .frame(maxWidth: .infinity, alignment: .leading)
                //     .background(
                //         RoundedRectangle(cornerRadius: Radius.l, style: .continuous)
                //             .fill(Color.cyan.opacity(0.2))
                //     )
                //     .padding(.horizontal, Spacing.xl)

                // Activity Chart
                ActivityChartCard()
                    .padding(.horizontal, Spacing.xl)

                // Monthly Activities
                MonthlyActivitiesCard()
                    .padding(.horizontal, Spacing.xl)
                    .padding(.bottom, Spacing.xl)
            }
            .padding(.top, Spacing.m)
        }
        .background(Color(.systemGray6))
        .navigationTitle("My Activity")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Calendar View

struct CalendarView: View {
    @Binding var currentMonth: Date
    @Binding var selectedDate: Date

    let daysOfWeek = ["M", "T", "W", "TH", "F", "S", "S"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack(spacing: Spacing.m) {
            // Month Header
            HStack {
                Text(monthYearString(from: currentMonth))
                    .appFont(.headline)
                    .foregroundStyle(AppColor.textPrimary)

                Spacer()

                HStack(spacing: Spacing.s) {
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(Color.black))
                    }

                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(Color.black))
                    }
                }
            }

            // Days of Week
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .appFont(.caption)
                        .foregroundStyle(AppColor.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar Days
            LazyVGrid(columns: columns, spacing: Spacing.s) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    if let date = date {
                        DayCell(date: date, selectedDate: $selectedDate)
                    } else {
                        Text("")
                            .frame(height: 40)
                    }
                }
            }
        }
        .padding(Spacing.l)
        .background(Color.white)
        .cornerRadius(Radius.l)
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

    func getDaysInMonth() -> [Date?] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: currentMonth)!
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        let offsetDays = (firstWeekday - 2 + 7) % 7

        var days: [Date?] = Array(repeating: nil, count: offsetDays)

        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: interval.start) {
                days.append(date)
            }
        }

        return days
    }
}

struct DayCell: View {
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
                .appFont(.subhead)
                .foregroundStyle(isSelected ? .white : AppColor.textPrimary)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isSelected ? Color.primary : (isToday ? Color.cyan.opacity(0.2) : Color.clear))
                )
        }
    }
}

// MARK: - Activity Chart Card

struct ActivityChartCard: View {
    let gymCount = 212
    let badmintonCount = 146

    var totalCount: Int {
        gymCount + badmintonCount
    }

    var gymPercentage: Double {
        Double(gymCount) / Double(totalCount)
    }

    var body: some View {
        HStack(alignment: .center, spacing: Spacing.l) {
            // Pie Chart
            ZStack {
                // Gym section (dark blue)
                Circle()
                    .trim(from: 0, to: gymPercentage)
                    .stroke(Color(red: 0.15, green: 0.25, blue: 0.35), lineWidth: 35)
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))

                // Badminton section (cyan)
                Circle()
                    .trim(from: gymPercentage, to: 1)
                    .stroke(Color.cyan, lineWidth: 35)
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                // Center values
                VStack(spacing: 0) {
                    Text("\(gymCount)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.35))

                    Text("\(badmintonCount)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.cyan)
                }
            }
            Spacer()
            // Legend
            VStack(alignment: .leading, spacing: Spacing.m) {
                HStack(spacing: Spacing.s) {
                    Circle()
                        .fill(Color(red: 0.15, green: 0.25, blue: 0.35))
                        .frame(width: 8, height: 8)

                    Text("Gym")
                        .appFont(.subhead)
                        .foregroundStyle(AppColor.textPrimary)
                }

                HStack(spacing: Spacing.s) {
                    Circle()
                        .fill(Color.cyan)
                        .frame(width: 8, height: 8)

                    Text("Badminton")
                        .appFont(.subhead)
                        .foregroundStyle(AppColor.textPrimary)
                }
            }

            Spacer()
        }
        .padding(Spacing.xl)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(Radius.l)
    }
}

// MARK: - Monthly Activities Card

struct MonthlyActivitiesCard: View {
    let activities = [
        ActivityItem(name: "Elite Fitness (Toul Tom Poung)", checkInTime: "5:00 PM"),
        ActivityItem(name: "Elite Fitness (Toul Tom Poung)", checkInTime: "5:00 PM"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            Text("January")
                .appFont(.headline)
                .foregroundStyle(AppColor.textPrimary)

            VStack(spacing: Spacing.l) {
                ForEach(activities) { activity in
                    ActivityRow(activity: activity)
                }
            }
        }
        .padding(Spacing.l)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(Radius.l)
    }
}

struct ActivityRow: View {
    let activity: ActivityItem

    var body: some View {
        HStack(spacing: Spacing.m) {
            Circle()
                .fill(Color(uiColor: .tertiarySystemFill))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(activity.name)
                    .appFont(.body)
                    .foregroundStyle(AppColor.textPrimary)

                Text("Check-in: \(activity.checkInTime)")
                    .appFont(.caption)
                    .foregroundStyle(AppColor.textSecondary)
            }

            Spacer()
        }
    }
}

// MARK: - Data Models

struct ActivityItem: Identifiable {
    let id = UUID()
    let name: String
    let checkInTime: String
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ActivityView()
    }
}
