//
//  HomePageView.swift
//  Onepazz
//
//  Created by Claude on 10/26/25.
//

import SwiftUI

struct HomePageView: View {
    @State private var selectedActivityFilter: ActivityFilter = .all

    let user: HomeUser

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.m) {
                // Welcome Header
                WelcomeHeaderView(user: user)

                // Visits Count Section
                VisitsCountView(count: user.visitsThisMonth, month: "December")

                // Featured Content Grid
                FeaturedContentGrid()

                // Recent Visit Section
                RecentVisitSection()

                // Activity Section
                ActivitySection(selectedFilter: $selectedActivityFilter)

                // Activity Grid based on filter
                ActivityGridView(selectedFilter: selectedActivityFilter)
            }
            .padding(.horizontal, Spacing.l)
            .padding(.vertical, Spacing.m)
        }
        .background(Color(.systemBackground))
        .navigationDestination(for: PartnerRoute.self) { route in
            GymDetailView(gym: .mock)
                .hideTabBarAndScanButton()
        }
    }
}

// MARK: - Welcome Header

// MARK: - Featured Content Grid

struct FeaturedContentGrid: View {
    var body: some View {
        GeometryReader { geometry in
            let cardSpacing = Spacing.m
            let availableWidth = geometry.size.width
            let smallCardWidth = (availableWidth - cardSpacing) * 0.45
            let largeCardWidth = availableWidth - smallCardWidth - cardSpacing
            let largeCardHeight: CGFloat = 200
            let smallCardHeight = (largeCardHeight - cardSpacing) / 2

            HStack(alignment: .top, spacing: cardSpacing) {
                // Large featured card
                FeaturedCard(
                    title: "Squats\nwith weight",
                    imageName: "featured1",
                    badgeCount: 15,
                    viewCount: "4GM",
                    isLarge: true,
                    width: largeCardWidth,
                    height: largeCardHeight
                )

                VStack(spacing: cardSpacing) {
                    // Small featured cards
                    FeaturedCard(
                        title: "CrossFit",
                        imageName: "featured2",
                        hasButton: true,
                        isLarge: false,
                        width: smallCardWidth,
                        height: smallCardHeight
                    )

                    FeaturedCard(
                        title: "CrossFit",
                        imageName: "featured3",
                        hasButton: true,
                        isLarge: false,
                        width: smallCardWidth,
                        height: smallCardHeight
                    )
                }
            }
        }
        .frame(height: 200)
    }
}

// MARK: - Activity Section

struct ActivitySection: View {
    @Binding var selectedFilter: ActivityFilter

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Activity")
                .appFont(.title3)
                .foregroundStyle(AppColor.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.m) {
                    ForEach(ActivityFilter.allCases, id: \.self) { filter in
                        HomeFilterChip(
                            title: filter.rawValue,
                            isSelected: selectedFilter == filter
                        ) {
                            selectedFilter = filter
                        }
                    }
                }
            }
        }
    }
}
// MARK: - Recent Visit Section

struct RecentVisitSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text("Recent Visit")
                    .appFont(.headline)
                    .foregroundStyle(AppColor.textSecondary)

                Spacer()

                Button {
                    // Handle view all
                } label: {
                    Text("View All")
                        .appFont(.subhead)
                        .foregroundStyle(Color.blue)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.l) {
                    ForEach(0..<3) { _ in
                        GymCardV2()
                    }
                }
            }
        }
    }
}

struct GymCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Gym Image
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 320, height: 180)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.5))
                    )
                    .clipShape(
                        .rect(
                            topLeadingRadius: Radius.l,
                            topTrailingRadius: Radius.l
                        )
                    )

                // Follow Us badge
                HStack(spacing: 4) {
                    Text("FOLLOW US")
                    Image(systemName: "chevron.right")
                }
                .appFont(.caption)
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.s)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.red)
                )
                .padding([.top, .trailing], Spacing.m)
            }

            // Gym Info
            HStack(spacing: Spacing.m) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray.opacity(0.5))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text("Alpha Plus Fitness")
                        .appFont(.body)
                        .foregroundStyle(AppColor.textPrimary)

                    Text("6:00 AM - 10:00 PM • 1 km away")
                        .appFont(.caption)
                        .foregroundStyle(AppColor.textSecondary)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 12))
                    Text("Standard Member")
                        .appFont(.caption)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: Radius.s, style: .continuous)
                        .fill(Color.black)
                )
            }
            .padding(Spacing.l)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(
                .rect(
                    bottomLeadingRadius: Radius.l,
                    bottomTrailingRadius: Radius.l
                )
            )
        }
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .frame(width: 320)
    }
}

// MARK: - Activity Grid View

struct ActivityGridView: View {
    let selectedFilter: ActivityFilter

    var filteredGyms: [(name: String, hours: String, distance: String, badge: String, type: ActivityFilter)] {
        let allGyms: [(name: String, hours: String, distance: String, badge: String, type: ActivityFilter)] = [
            ("Alpha Plus Fitness", "6:00 AM - 10:00 PM", "1 km away", "Standard Member", .gym),
            ("Gold's Gym", "5:00 AM - 11:00 PM", "2 km away", "Premium Member", .gym),
            ("Fitness First", "7:00 AM - 9:00 PM", "3 km away", "Basic Member", .gym),
            ("Olympic Pool", "6:00 AM - 8:00 PM", "1.5 km away", "Member", .pool),
            ("Aquatic Center", "7:00 AM - 9:00 PM", "2.5 km away", "Premium Member", .pool),
            ("Badminton Arena", "8:00 AM - 10:00 PM", "1 km away", "Member", .badminton),
            ("Sport Court", "6:00 AM - 11:00 PM", "3 km away", "Standard Member", .badminton),
        ]

        if selectedFilter == .all {
            return allGyms
        } else {
            return allGyms.filter { $0.type == selectedFilter }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            ForEach(0..<filteredGyms.count, id: \.self) { index in
                NavigationLink(value: PartnerRoute(id: filteredGyms[index].name.lowercased().replacingOccurrences(of: " ", with: "-"))) {
                    ActivityGymCard(
                        name: filteredGyms[index].name,
                        hours: filteredGyms[index].hours,
                        distance: filteredGyms[index].distance,
                        badge: filteredGyms[index].badge
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ActivityGymCard: View {
    let name: String
    let hours: String
    let distance: String
    let badge: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Gym Image
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 180)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.5))
                    )
                    .clipShape(
                        .rect(
                            topLeadingRadius: Radius.l,
                            topTrailingRadius: Radius.l
                        )
                    )

                // Follow Us badge
                HStack(spacing: 4) {
                    Text("FOLLOW US")
                        .font(.system(size: 10, weight: .semibold))
                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Image(systemName: "arrow.right")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.red)
                        )
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.red.opacity(0.9))
                )
                .padding([.top, .trailing], Spacing.m)
            }

            // Gym Info
            HStack(spacing: Spacing.m) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray.opacity(0.5))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .appFont(.body)
                        .foregroundStyle(AppColor.textPrimary)

                    Text("\(hours) \n\(distance)")
                        .appFont(.caption)
                        .foregroundStyle(AppColor.textSecondary)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 12))
                    Text(badge)
                        .appFont(.caption)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: Radius.s, style: .continuous)
                        .fill(Color.black)
                )
            }
            .padding(Spacing.l)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(
                .rect(
                    bottomLeadingRadius: Radius.l,
                    bottomTrailingRadius: Radius.l
                )
            )
        }
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - New Activity Grid View

struct ActivityGridViewV2: View {
    let selectedFilter: ActivityFilter

    var filteredGyms: [(name: String, hours: String, distance: String, badge: String, type: ActivityFilter)] {
        let allGyms: [(name: String, hours: String, distance: String, badge: String, type: ActivityFilter)] = [
            ("Alpha Plus Fitness", "6:00 AM - 10:00 PM", "1 km away", "Standard Member", .gym),
            ("Gold's Gym", "5:00 AM - 11:00 PM", "2 km away", "Premium Member", .gym),
            ("Fitness First", "7:00 AM - 9:00 PM", "3 km away", "Basic Member", .gym),
            ("Olympic Pool", "6:00 AM - 8:00 PM", "1.5 km away", "Member", .pool),
            ("Aquatic Center", "7:00 AM - 9:00 PM", "2.5 km away", "Premium Member", .pool),
            ("Badminton Arena", "8:00 AM - 10:00 PM", "1 km away", "Member", .badminton),
            ("Sport Court", "6:00 AM - 11:00 PM", "3 km away", "Standard Member", .badminton),
        ]

        if selectedFilter == .all {
            return allGyms
        } else {
            return allGyms.filter { $0.type == selectedFilter }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            ForEach(0..<filteredGyms.count, id: \.self) { index in
                NavigationLink(value: PartnerRoute(id: filteredGyms[index].name.lowercased().replacingOccurrences(of: " ", with: "-"))) {
                    ActivityGymCardV2(
                        name: filteredGyms[index].name,
                        hours: filteredGyms[index].hours,
                        distance: filteredGyms[index].distance,
                        badge: filteredGyms[index].badge
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ActivityGymCardV2: View {
    let name: String
    let hours: String
    let distance: String
    let badge: String

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main gym image with overlay
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 220)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                )
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            // Top right "FOLLOW US" badge
            VStack {
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Text("FOLLOW US")
                            .font(.system(size: 10, weight: .semibold))
                        Circle()
                            .fill(Color.white)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.red)
                            )
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.red.opacity(0.9))
                    )
                    .padding([.top, .trailing], Spacing.l)
                }
                Spacer()
            }

            // Bottom frosted glass info card
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(2)

                        Text("\(hours)\n\(distance)")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    // Standard Member badge
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 9))
                        Text(badge)
                            .font(.system(size: 10, weight: .medium))
                            .lineLimit(2)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.black)
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .frame(height: 220)
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Preview

#Preview {
    HomePageView(user: HomeUser(
        name: "Sokunviseth",
        avatarImage: "user_avatar",
        visitsThisMonth: 20
    ))
}
