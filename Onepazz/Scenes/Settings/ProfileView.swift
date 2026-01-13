//
//  ProfileView.swift
//  Onepazz
//
//  Created by Claude on 10/26/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var userName = "Por Sokunviseth"

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Profile Avatar
                VStack(spacing: Spacing.m) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.5))
                        )

                    HStack(spacing: Spacing.xs) {
                        Text(userName)
                            .appFont(.headline)
                            .foregroundStyle(AppColor.textPrimary)

                        Button {
                            // Handle edit name
                        } label: {
                            Image(systemName: "pencil")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.top, Spacing.l)

                // Personal Information
                InfoCard(title: "Personal Information") {
                    InfoRow(label: "Name:", value: userName)
                    InfoRow(label: "Gender:", value: "Male")
                    InfoRow(label: "Phone:", value: "070 124 123")
                    InfoRow(label: "Join Since", value: "October 2023")
                    InfoRow(label: "Company", value: "Wing Bank")
                }

                // Subscription Information
                InfoCard(title: "Subscription Information") {
                    InfoRow(label: "Type", value: "Standard")
                    InfoRow(label: "Price", value: "$29.99 per month")
                    InfoRow(label: "Expire Date", value: "June 12 2025")

                    // Subscription Plan Section
                    VStack(alignment: .leading, spacing: Spacing.m) {
                        HStack {
                            Button {
                                // Switch to Basic
                            } label: {
                                Text("Basic")
                                    .appFont(.subhead)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, Spacing.l)
                                    .padding(.vertical, Spacing.xs)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.cyan)
                                    )
                            }

                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: Spacing.s) {
                            Text("Free")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)

                            Text("forever")
                                .appFont(.subhead)
                                .foregroundColor(.white.opacity(0.8))

                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                HStack(spacing: Spacing.xs) {
                                    Text("•")
                                        .foregroundColor(.white)
                                    Text("100 gyms")
                                        .appFont(.subhead)
                                        .foregroundColor(.white)
                                }

                                HStack(spacing: Spacing.xs) {
                                    Text("•")
                                        .foregroundColor(.white)
                                    Text("20 sport clubs")
                                        .appFont(.subhead)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top, Spacing.s)
                        }
                        .padding(Spacing.l)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.3, green: 0.5, blue: 0.6), Color(red: 0.2, green: 0.3, blue: 0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(Radius.l)
                    }
                    .padding(.top, Spacing.m)
                }

                // Subscription History
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Subscription History")
                        .appFont(.headline)
                        .foregroundStyle(AppColor.textPrimary)

                    HistoryCard(
                        price: "$29.99",
                        type: "Standard",
                        time: "11:00 am",
                        date: "January 2025"
                    )
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xl)
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .hideTabBarAndScanButton()
    }
}

// MARK: - Info Card

struct InfoCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(title)
                .appFont(.headline)
                .foregroundStyle(AppColor.textPrimary)

            VStack(spacing: 0) {
                content
            }
        }
        .padding(Spacing.l)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(Radius.l)
        .padding(.horizontal, Spacing.xl)
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .appFont(.subhead)
                .foregroundStyle(AppColor.textSecondary)
                .frame(width: 100, alignment: .leading)

            Text(value)
                .appFont(.subhead)
                .foregroundStyle(AppColor.textPrimary)

            Spacer()
        }
        .padding(.vertical, Spacing.m)
    }
}

// MARK: - History Card

struct HistoryCard: View {
    let price: String
    let type: String
    let time: String
    let date: String

    var body: some View {
        HStack {
            Text("\(price) (\(type))")
                .appFont(.subhead)
                .foregroundStyle(AppColor.textPrimary)

            Spacer()

            Text(time)
                .appFont(.subhead)
                .foregroundStyle(AppColor.textSecondary)

            Spacer()

            Text(date)
                .appFont(.subhead)
                .foregroundStyle(AppColor.textSecondary)
        }
        .padding(Spacing.l)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(Radius.l)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProfileView()
    }
}
