//
//  GymDetailView.swift
//  Onepazz
//
//  Created by Claude on 10/26/25.
//

import SwiftUI

struct GymDetailView: View {
    @State private var selectedImageIndex = 0

    let gym: GymDetail

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image Carousel
                HeroCarouselView(
                    images: gym.images,
                    selectedIndex: $selectedImageIndex
                )

                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Gym Info Section
                    GymInfoSection(gym: gym)

                    Divider()

                    // Facilities Section
                    FacilitiesSection(facilities: gym.facilities)

                    Divider()

                    // Class Schedule Section
                    if !gym.classSchedules.isEmpty {
                        ClassScheduleSection(schedules: gym.classSchedules)
                        Divider()
                    }

                    // Opening Hours Section
                    OpeningHoursSection(openingHours: gym.openingHours)

                    Divider()

                    // Rating and Reviews Section
                    RatingReviewsSection(reviews: gym.reviews)
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xl)
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) {
            GetDirectionButton(address: gym.address)
        }
        .toolbar(.hidden, for:.tabBar)
        .scanButtonVisible(false) 
        .customBackButton()
    }
}

// MARK: - Hero Carousel

struct HeroCarouselView: View {
    let images: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedIndex) {
                ForEach(Array(images.enumerated()), id: \.offset) { index, imageName in
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 280)

            // Custom Page Indicators
            HStack(spacing: 6) {
                ForEach(0..<images.count, id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.black : Color.gray.opacity(0.3))
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.vertical, Spacing.m)
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

// MARK: - Gym Info Section

struct GymInfoSection: View {
    let gym: GymDetail

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(gym.name)
                .appFont(.title2)
                .foregroundStyle(AppColor.textPrimary)

            Text(gym.ownerName)
                .appFont(.subhead)
                .foregroundStyle(AppColor.textSecondary)

            VStack(alignment: .leading, spacing: Spacing.s) {
                Text("about".localized)
                    .appFont(.headline)
                    .foregroundStyle(AppColor.textPrimary)

                Text(gym.about)
                    .appFont(.subhead)
                    .foregroundStyle(AppColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, Spacing.s)
        }
    }
}

// MARK: - Facilities Section

struct FacilitiesSection: View {
    let facilities: [Facility]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("facilities".localized)
                .appFont(.subhead)
                .foregroundStyle(AppColor.textSecondary)

            VStack(spacing: Spacing.m) {
                ForEach(facilities) { facility in
                    HStack(spacing: Spacing.l) {
                        Image(systemName: facility.iconName)
                            .font(.system(size: 24))
                            .foregroundStyle(AppColor.textPrimary)
                            .frame(width: 32)

                        Text(facility.name)
                            .appFont(.body)
                            .foregroundStyle(AppColor.textPrimary)

                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Class Schedule Section

struct ClassScheduleSection: View {
    let schedules: [ClassSchedule]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            Text("class_schedule".localized)
                .appFont(.headline)
                .foregroundStyle(AppColor.textPrimary)

            VStack(alignment: .leading, spacing: Spacing.l) {
                ForEach(schedules) { schedule in
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(schedule.className)
                            .appFont(.body)
                            .foregroundStyle(AppColor.textPrimary)

                        Text("day".localized(schedule.days))
                            .appFont(.subhead)
                            .foregroundStyle(AppColor.textSecondary)

                        Text("time".localized(schedule.time))
                            .appFont(.subhead)
                            .foregroundStyle(AppColor.textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Opening Hours Section

struct OpeningHoursSection: View {
    let openingHours: OpeningHours

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("opening_hour".localized)
                .appFont(.headline)
                .foregroundStyle(AppColor.textPrimary)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(openingHours.status)
                    .appFont(.subhead)
                    .foregroundStyle(AppColor.textSecondary)

                Text("from_to_time".localized(openingHours.openTime, openingHours.closeTime))
                    .appFont(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColor.textPrimary)

                if let note = openingHours.note {
                    Text(note)
                        .appFont(.footnote)
                        .foregroundStyle(AppColor.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

// MARK: - Rating and Reviews Section

struct RatingReviewsSection: View {
    let reviews: [Review]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            Text("rating_reviews".localized)
                .appFont(.headline)
                .foregroundStyle(AppColor.textPrimary)

            VStack(spacing: Spacing.l) {
                ForEach(reviews) { review in
                    ReviewCard(review: review)
                }
            }
        }
        .padding(.bottom, 80) // Space for bottom button
    }
}

struct ReviewCard: View {
    let review: Review

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.m) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.gray.opacity(0.5))
                )

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(review.userName)
                    .appFont(.headline)
                    .foregroundStyle(AppColor.textPrimary)

                HStack(spacing: 2) {
                    Text("rating".localized(String(format: "%.1f", review.rating)))
                        .appFont(.caption)
                        .foregroundStyle(AppColor.textSecondary)

                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(review.rating) ? "star.fill" : "star")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.yellow)
                    }
                }

                Text(review.comment)
                    .appFont(.subhead)
                    .foregroundStyle(AppColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(Spacing.l)
        .background(
            RoundedRectangle(cornerRadius: Radius.m, style: .continuous)
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: - Get Direction Button

struct GetDirectionButton: View {
    let address: String

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: Spacing.m) {
                Image(systemName: "mappin.circle")
                    .font(.system(size: 24))
                    .foregroundStyle(AppColor.textPrimary)

                VStack(alignment: .leading, spacing: 2) {
                    Text(address)
                        .appFont(.body)
                        .foregroundStyle(AppColor.textPrimary)
                        .lineLimit(2)
                }

                Spacer()

                Button {
                    // Handle get direction
                } label: {
                    Text("get_direction".localized)
                        .appFont(.subhead)
                        .foregroundStyle(.white)
                        .padding(.horizontal, Spacing.l)
                        .padding(.vertical, Spacing.m)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.s, style: .continuous)
                                .fill(Color(.darkGray))
                        )
                }
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.l)
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Data Models

struct GymDetail {
    let id: String
    let name: String
    let ownerName: String
    let about: String
    let images: [String]
    let facilities: [Facility]
    let classSchedules: [ClassSchedule]
    let openingHours: OpeningHours
    let address: String
    let reviews: [Review]
}

struct Facility: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
}

struct ClassSchedule: Identifiable {
    let id = UUID()
    let className: String
    let days: String
    let time: String
}

struct OpeningHours {
    let status: String
    let openTime: String
    let closeTime: String
    let note: String?
}

struct Review: Identifiable {
    let id = UUID()
    let userName: String
    let userAvatar: String
    let rating: Double
    let comment: String
}

// MARK: - Preview

#Preview {
    GymDetailView(gym: GymDetail(
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
    ))
}
