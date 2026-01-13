//
//  SettingsView.swift
//  Onepazz
//
//  Created by Claude on 10/26/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // Settings Section
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    SettingsCard {
                        SettingsRow(icon: "person.circle", title: "Profile", destination: AnyView(ProfileView()))
                        Divider().padding(.leading, 56)
                        SettingsRow(icon: "globe", title: "Language", destination: AnyView(Text("Language")))
                        Divider().padding(.leading, 56)
                        SettingsRow(icon: "bell.circle", title: "Notification", destination: AnyView(Text("Notification")))
                        Divider().padding(.leading, 56)
                        SettingsRow(icon: "creditcard.circle", title: "Plan and Pricing", destination: AnyView(BecomeMemberView()))
                    }
                }

                // Info Section
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Info")
                        .appFont(.headline)
                        .foregroundStyle(AppColor.textSecondary)
                        .padding(.horizontal, Spacing.xl)

                    SettingsCard {
                        SettingsRow(icon: "info.circle.fill", title: "About Us", destination: AnyView(Text("About Us")))
                        Divider().padding(.leading, 56)
                        SettingsRow(icon: "book.circle.fill", title: "Our Story", destination: AnyView(Text("Our Story")))
                        Divider().padding(.leading, 56)
                        SettingsRow(icon: "doc.text.fill", title: "Term and Condition", destination: AnyView(Text("Terms and Conditions")))
                    }
                }

                // Social Section
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Social")
                        .appFont(.headline)
                        .foregroundStyle(AppColor.textSecondary)
                        .padding(.horizontal, Spacing.xl)

                    HStack(spacing: Spacing.xl) {
                        SocialButton(icon: "logo.facebook")
                        SocialButton(icon: "logo.instagram")
                        SocialButton(icon: "logo.youtube")
                        SocialButton(icon: "paperplane.circle.fill")
                        SocialButton(icon: "logo.facebook")
                    }
                    .padding(.horizontal, Spacing.xl)
                }

                // Sign Out Button
                Button {
                    // Handle sign out
                } label: {
                    Text("Sign out")
                        .appFont(.body)
                        .foregroundStyle(AppColor.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.l)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.l, style: .continuous)
                                .fill(Color(uiColor: .secondarySystemBackground))
                        )
                }
                .padding(.horizontal, Spacing.xl)

                // Version
                Text("Version: 1.0.0")
                    .appFont(.subhead)
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, Spacing.xl)
            }
            .padding(.top, Spacing.m)
        }
        .background(Color(.systemGray6))
        .navigationTitle("Setting")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Settings Card

struct SettingsCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(Radius.l)
        .padding(.horizontal, Spacing.xl)
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let title: String
    let destination: AnyView

    var body: some View {
        NavigationLink(destination: destination.customBackButton()) {
            HStack(spacing: Spacing.m) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(width: 24)

                Text(title)
                    .appFont(.subhead)
                    .foregroundStyle(AppColor.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColor.textSecondary)
            }
            .padding(.horizontal, Spacing.l)
            .padding(.vertical, Spacing.l)
        }
    }
}

// MARK: - Social Button

struct SocialButton: View {
    let icon: String

    var body: some View {
        Button {
            // Handle social media tap
        } label: {
            Circle()
                .fill(Color.black)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon == "logo.facebook" ? "f.circle.fill" :
                          icon == "logo.instagram" ? "camera.circle.fill" :
                          icon == "logo.youtube" ? "play.circle.fill" :
                          icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                )
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SettingsView()
    }
}
