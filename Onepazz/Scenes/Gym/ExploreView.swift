//
//  ExploreView.swift
//  Onepazz
//
//  Created by Claude on 10/26/25.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @State private var selectedCategory: ExploreCategory = .all

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.l) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal, Spacing.xl)

                // Category Filter
                CategoryFilterView(selectedCategory: $selectedCategory)
                    .padding(.horizontal, Spacing.xl)

                // Gym List
                VStack(spacing: Spacing.l) {
                    ForEach(filteredGyms) { gym in
                        NavigationLink(value: PartnerRoute(id: gym.id)) {
                            ExploreGymCard(gym: gym)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Spacing.xl)
            }
            .padding(.vertical, Spacing.m)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: PartnerRoute.self) { route in
            GymDetailView(gym: .mock)
                .hideTabBarAndScanButton()
        }
    }

    var filteredGyms: [ExploreGym] {
        let gyms = ExploreGym.mockData

        if selectedCategory == .all {
            return gyms
        } else {
            return gyms.filter { $0.category == selectedCategory }
        }
    }
}

// MARK: - Search Bar

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search", text: $text)
                .appFont(.body)
        }
        .padding(Spacing.m)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(Radius.m)
    }
}

// MARK: - Category Filter

enum ExploreCategory: String, CaseIterable {
    case all = "All"
    case food = "Food"
    case drink = "Drink"
    case protein = "Protein"
}

struct CategoryFilterView: View {
    @Binding var selectedCategory: ExploreCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.m) {
                ForEach(ExploreCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .appFont(.subhead)
                .foregroundStyle(isSelected ? .white : AppColor.textSecondary)
                .padding(.horizontal, Spacing.l)
                .padding(.vertical, Spacing.s)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(isSelected ? Color.black : Color(.systemGray6))
                )
        }
    }
}

// MARK: - Explore Gym Card

struct ExploreGymCard: View {
    let gym: ExploreGym

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Gym Banner Image
            Rectangle()
                .fill(Color.red.opacity(0.8))
                .frame(height: 180)
                .overlay(
                    VStack {
                        Text("GYM")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                        Text("FITNESS")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                    }
                )
                .overlay(
                    HStack {
                        VStack(alignment: .leading) {
                            Spacer()

                            Button {
                                // Handle join
                            } label: {
                                Text("JOIN US")
                                    .appFont(.caption)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, Spacing.l)
                                    .padding(.vertical, Spacing.xs)
                                    .background(
                                        Capsule()
                                            .fill(Color.yellow)
                                    )
                            }
                            .padding(Spacing.l)
                        }

                        Spacer()

                        VStack(alignment: .trailing) {
                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                HStack(spacing: 4) {
                                    Image(systemName: "tag.fill")
                                        .font(.system(size: 10))
                                    Text("50% DISCOUNT")
                                        .font(.system(size: 10, weight: .bold))
                                }
                                .foregroundColor(.red)

                                Text("FOR THIS WEEK ONLY")
                                    .font(.system(size: 8))
                                    .foregroundColor(.gray)
                            }
                            .padding(Spacing.s)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.white)
                            )
                            .padding(Spacing.l)
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: Radius.l, style: .continuous))

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
                    Text(gym.name)
                        .appFont(.body)
                        .foregroundStyle(AppColor.textPrimary)

                    Text("\(gym.hours) | \(gym.distance)")
                        .appFont(.caption)
                        .foregroundStyle(AppColor.textSecondary)
                }

                Spacer()
            }
        }
    }
}

// MARK: - Data Models

struct ExploreGym: Identifiable {
    let id: String
    let name: String
    let hours: String
    let distance: String
    let category: ExploreCategory
}

extension ExploreGym {
    static let mockData: [ExploreGym] = [
        ExploreGym(id: "1", name: "Alpha Plus Fitness (Toul Tom Poung)", hours: "6:00 AM - 10:00 PM", distance: "1 km away", category: .all),
        ExploreGym(id: "2", name: "Gold's Gym", hours: "5:00 AM - 11:00 PM", distance: "2 km away", category: .all),
        ExploreGym(id: "3", name: "Fitness First", hours: "7:00 AM - 9:00 PM", distance: "3 km away", category: .all),
        ExploreGym(id: "4", name: "CrossFit Arena", hours: "6:00 AM - 10:00 PM", distance: "1.5 km away", category: .all),
        ExploreGym(id: "5", name: "Yoga Studio", hours: "8:00 AM - 8:00 PM", distance: "2.5 km away", category: .all),
    ]
}

extension GymDetail {
    static let mockForList = GymDetail(
        id: "1",
        name: "Gym Fitness",
        ownerName: "Boeng Keng Kang",
        about: "Established in 2015, FitLife Community Gym has become a cornerstone of health and wellness in our neighborhood. Our mission is to empower individuals of all ages and fitness levels to lead healthier, more active lives.",
        images: ["gym1", "gym2", "gym3"],
        facilities: [
            Facility(name: "Gym", iconName: "figure.strengthtraining.traditional"),
            Facility(name: "Pool", iconName: "figure.pool.swim"),
            Facility(name: "Steam", iconName: "wind"),
            Facility(name: "Sauna", iconName: "humidity")
        ],
        classSchedules: [
            ClassSchedule(className: "Yoga class", days: "Every Thursday and Friday", time: "5:30 pm - 7:00 pm"),
            ClassSchedule(className: "Jumping Class", days: "Every Monday, Wednesday and Friday", time: "5:30 pm - 7:00 pm")
        ],
        openingHours: OpeningHours(
            status: "Gym is open today",
            openTime: "6:00 am",
            closeTime: "10:00 pm",
            note: "On public holiday such as Khmer New Year and Pchum Ben this place might be close so please check the availability before you go."
        ),
        address: "#12 street 310 Boeng Keng Kang Phnom Penh",
        reviews: [
            Review(userName: "Tommy", userAvatar: "avatar1", rating: 5.0, comment: "I don't have to buy more subscription to go to gym, swimming and tennis")
        ]
    )
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ExploreView()
    }
}
