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

                // Activity Chart
                ActivityChartCard()
                    .padding(.horizontal, Spacing.xl)

                // Monthly Activities
                MonthlyActivitiesCard()
                    .padding(.horizontal, Spacing.xl)
                    .padding(.bottom, 100)
            }
            .padding(.top, Spacing.m)
        }
        .background(Color(.systemGray6))
        .navigationTitle("my_activity".localized)
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
    @Environment(\.theme) var theme

    let moveCalories = 120
    let moveGoal = 290
    let exerciseMinutes = 21
    let exerciseGoal = 30
    let standHours = 4
    let standGoal = 12

    var movePercentage: Double {
        Double(moveCalories) / Double(moveGoal)
    }

    var exercisePercentage: Double {
        Double(exerciseMinutes) / Double(exerciseGoal)
    }

    var standPercentage: Double {
        Double(standHours) / Double(standGoal)
    }

    var body: some View {
        HStack(spacing: Spacing.xl) {
            // Progress bars section
            VStack(alignment: .leading, spacing: Spacing.l) {
                ActivityProgressRow(
                    title: "move".localized,
                    value: "\(moveCalories)/\(moveGoal) cal",
                    percentage: movePercentage,
                    color: .pink
                )

                ActivityProgressRow(
                    title: "exercise".localized,
                    value: "\(exerciseMinutes)/\(exerciseGoal) mins",
                    percentage: exercisePercentage,
                    color: Color(red: 0.5, green: 0.9, blue: 0.8)
                )

                ActivityProgressRow(
                    title: "stand".localized,
                    value: "\(standHours)/\(standGoal) hrs",
                    percentage: standPercentage,
                    color: Color(red: 0.4, green: 0.8, blue: 1.0)
                )
            }

            Spacer()

            // Concentric Ring Chart
            ZStack {
                // Outer ring background - Move
                Circle()
                    .stroke(Color.pink.opacity(0.15), style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .frame(width: 120, height: 120)

                // Outer ring - Move (pink)
                Circle()
                    .trim(from: 0, to: movePercentage)
                    .stroke(Color.pink, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))

                // Middle ring background - Exercise
                Circle()
                    .stroke(Color(red: 0.5, green: 0.9, blue: 0.8).opacity(0.15), style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .frame(width: 88, height: 88)

                // Middle ring - Exercise (mint/cyan)
                Circle()
                    .trim(from: 0, to: exercisePercentage)
                    .stroke(Color(red: 0.5, green: 0.9, blue: 0.8), style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .frame(width: 88, height: 88)
                    .rotationEffect(.degrees(-90))

                // Inner ring background - Stand
                Circle()
                    .stroke(Color(red: 0.4, green: 0.8, blue: 1.0).opacity(0.15), style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .frame(width: 56, height: 56)

                // Inner ring - Stand (light blue)
                Circle()
                    .trim(from: 0, to: standPercentage)
                    .stroke(Color(red: 0.4, green: 0.8, blue: 1.0), style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .frame(width: 56, height: 56)
                    .rotationEffect(.degrees(-90))
            }
        }
        .padding(Spacing.xl)
        .background(Color(theme.colors.surfaceVariant))
        .cornerRadius(Radius.l)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Activity Progress Row

struct ActivityProgressRow: View {
    @Environment(\.theme) var theme

    let title: String
    let value: String
    let percentage: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(theme.colors.textPrimary))

                Spacer()

                Text(value)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(theme.colors.textSecondary))
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Capsule()
                        .fill(color.opacity(0.2))
                        .frame(height: 8)

                    // Progress
                    Capsule()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
        }
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
            Text("january".localized)
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
        .scanButtonVisible(true)
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

                Text("check_in".localized(activity.checkInTime))
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
