//
//  BecomeMemberView.swift
//  Onepazz
//
//  Created by Claude on 10/26/25.
//

import SwiftUI

struct BecomeMemberView: View {
    @State private var selectedPlan: SubscriptionPlan? = .standard

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Title
                    Text("Become a member")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(AppColor.textPrimary)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.m)

                    // Subscription Plans
                    VStack(spacing: Spacing.l) {
                        SubscriptionCard(
                            plan: .standard,
                            isSelected: selectedPlan == .standard
                        ) {
                            selectedPlan = .standard
                        }

                        SubscriptionCard(
                            plan: .premium,
                            isSelected: selectedPlan == .premium
                        ) {
                            selectedPlan = .premium
                        }

                        SubscriptionCard(
                            plan: .silver,
                            isSelected: selectedPlan == .silver
                        ) {
                            selectedPlan = .silver
                        }

                        SubscriptionCard(
                            plan: .gold,
                            isSelected: selectedPlan == .gold
                        ) {
                            selectedPlan = .gold
                        }
                    }
                    .padding(.horizontal, Spacing.xl)
                    .padding(.bottom, Spacing.xxl)
                }
            }

            // Footer
            VStack(spacing: Spacing.l) {
                // Continue Button
                Button {
                    // Handle purchase
                } label: {
                    Text("Continue to purchase")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.l)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.m, style: .continuous)
                                .fill(Color.primary)
                        )
                }
                .padding(.horizontal, Spacing.xl)

                // Terms and Policy
                HStack(spacing: Spacing.m) {
                    Button {
                        // Navigate to Terms
                    } label: {
                        Text("Term and Condition")
                            .appFont(.body)
                            .foregroundStyle(AppColor.textPrimary)
                    }

                    Text("/")
                        .appFont(.body)
                        .foregroundStyle(AppColor.textSecondary)

                    Button {
                        // Navigate to Policy
                    } label: {
                        Text("Policy")
                            .appFont(.body)
                            .foregroundStyle(AppColor.textPrimary)
                    }
                }
                .padding(.bottom, Spacing.l)
            }
            .padding(.top, Spacing.l)
            .background(Color(uiColor: .systemBackground))
        }
        .background(Color(uiColor: .systemBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .hideTabBarAndScanButton()
    }
}

// MARK: - Subscription Card

struct SubscriptionCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(plan.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(isSelected ? .white : plan.accentColor)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text("•")
                            Text("100 gyms")
                                .appFont(.caption)
                        }

                        HStack(spacing: 4) {
                            Text("•")
                            Text("50 Sport clubs")
                                .appFont(.caption)
                        }
                    }
                    .foregroundStyle(isSelected ? .white.opacity(0.9) : AppColor.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(plan.price)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(isSelected ? .white : AppColor.textPrimary)

                    Text("Monthly")
                        .appFont(.caption)
                        .foregroundStyle(isSelected ? .white.opacity(0.9) : AppColor.textSecondary)
                }
            }
            .padding(Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: Radius.l, style: .continuous)
                    .fill(isSelected ? plan.backgroundColor : Color(uiColor: .secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: Radius.l, style: .continuous)
                    .strokeBorder(!isSelected ? (plan == .standard ? .white : plan.accentColor) : Color.clear, lineWidth: 2)
            )
            .overlay(alignment: .leading) {
                // Selected indicator - outside the card border
                if isSelected {
                    Circle()
                        .fill(Color(red: 0.2, green: 0.3, blue: 0.4))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color.yellow)
                        )
                        .offset(x: -22, y: 0)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Subscription Plan Model

enum SubscriptionPlan: String, CaseIterable {
    case standard = "Standard"
    case premium = "Premium"
    case silver = "Silver"
    case gold = "Gold"

    var name: String {
        rawValue
    }

    var price: String {
        switch self {
        case .standard: return "$29.99"
        case .premium: return "$59.99"
        case .silver: return "$89.99"
        case .gold: return "$109.99"
        }
    }

    var accentColor: Color {
        switch self {
        case .standard: return Color(red: 0.3, green: 0.5, blue: 0.6)
        case .premium: return Color.cyan
        case .silver: return Color.gray
        case .gold: return Color.yellow
        }
    }

    var backgroundColor: Color {
        Color(red: 0.3, green: 0.5, blue: 0.6)
    }

    var isHighlighted: Bool {
        self == .standard
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        BecomeMemberView()
    }
}
