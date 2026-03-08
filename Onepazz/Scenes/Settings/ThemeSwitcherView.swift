//
//  ThemeSwitcherView.swift
//  Onepazz
//
//  Created by Claude on 2/22/26.
//

import SwiftUI

struct ThemeSwitcherView: View {
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                ForEach(theme.availableThemes) { availableTheme in
                    ThemeRow(
                        themeConfig: availableTheme,
                        isSelected: availableTheme.id == theme.currentTheme.id,
                        onSelect: {
                            theme.setTheme(id: availableTheme.id)
                        }
                    )
                }
            } header: {
                Text("available_themes".localized)
                    .font(.themed(theme.typography.subhead))
            }

            Section {
                Button(action: {
                    // Demo: Create a custom theme
                    let customTheme = ThemeConfiguration(
                        id: "custom_\(UUID().uuidString.prefix(8))",
                        name: "custom",
                        displayName: "My Custom Theme",
                        isCustom: true,
                        colors: ColorPalette(
                            primary: CodableColor(red: 0.8, green: 0.2, blue: 0.4),
                            primaryVariant: CodableColor(red: 0.7, green: 0.1, blue: 0.3),
                            onPrimary: CodableColor(red: 1, green: 1, blue: 1),
                            secondary: CodableColor(red: 0.9, green: 0.7, blue: 0.2),
                            secondaryVariant: CodableColor(red: 0.8, green: 0.6, blue: 0.1),
                            onSecondary: CodableColor(red: 0, green: 0, blue: 0),
                            background: CodableColor(red: 1, green: 1, blue: 1),
                            surface: CodableColor(red: 0.95, green: 0.95, blue: 0.95),
                            surfaceVariant: CodableColor(red: 0.9, green: 0.9, blue: 0.9),
                            textPrimary: CodableColor(red: 0.1, green: 0.1, blue: 0.1),
                            textSecondary: CodableColor(red: 0.4, green: 0.4, blue: 0.4),
                            textTertiary: CodableColor(red: 0.6, green: 0.6, blue: 0.6),
                            textInverse: CodableColor(red: 1, green: 1, blue: 1),
                            accent: CodableColor(red: 0.8, green: 0.2, blue: 0.4),
                            error: CodableColor(red: 0.9, green: 0.2, blue: 0.2),
                            warning: CodableColor(red: 1, green: 0.6, blue: 0),
                            success: CodableColor(red: 0.2, green: 0.8, blue: 0.3),
                            info: CodableColor(red: 0.2, green: 0.5, blue: 0.9),
                            overlay: CodableColor(red: 0, green: 0, blue: 0, opacity: 0.5),
                            scrim: CodableColor(red: 0, green: 0, blue: 0, opacity: 0.7),
                            border: CodableColor(red: 0.8, green: 0.8, blue: 0.8),
                            divider: CodableColor(red: 0.7, green: 0.7, blue: 0.7),
                            brandPrimary: CodableColor(red: 0.8, green: 0.2, blue: 0.4),
                            brandSecondary: CodableColor(red: 0.9, green: 0.7, blue: 0.2),
                            brandAccent: CodableColor(red: 1, green: 0.3, blue: 0.5),
                            card: CodableColor(red: 0.98, green: 0.98, blue: 0.98),
                            cardHighlight: CodableColor(red: 0.8, green: 0.2, blue: 0.4, opacity: 0.1)
                        )
                    )
                    theme.addCustomTheme(customTheme)
                    theme.setTheme(customTheme)
                }) {
                    HStack(spacing: theme.spacing.m) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: theme.icons.medium))
                            .foregroundColor(Color(theme.colors.accent))

                        Text("add_custom_theme".localized)
                            .font(.themed(theme.typography.body))
                            .foregroundColor(Color(theme.colors.accent))
                    }
                    .padding(.vertical, theme.spacing.s)
                }
            } header: {
                Text("custom_themes".localized)
                    .font(.themed(theme.typography.subhead))
            }
        }
        .navigationTitle("theme_settings".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct ThemeRow: View {
    @Environment(\.theme) var theme
    let themeConfig: ThemeConfiguration
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: theme.spacing.m) {
                // Color preview
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(themeConfig.colors.primary))
                        .frame(width: 24, height: 24)

                    Circle()
                        .fill(Color(themeConfig.colors.secondary))
                        .frame(width: 24, height: 24)

                    Circle()
                        .fill(Color(themeConfig.colors.accent))
                        .frame(width: 24, height: 24)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(themeConfig.displayName)
                        .font(.themed(theme.typography.body))
                        .foregroundColor(Color(theme.colors.textPrimary))

                    if themeConfig.isCustom {
                        Text("custom".localized)
                            .font(.themed(theme.typography.caption))
                            .foregroundColor(Color(theme.colors.textSecondary))
                    }
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: theme.icons.medium))
                        .foregroundColor(Color(theme.colors.accent))
                }
            }
            .padding(.vertical, theme.spacing.xs)
        }
    }
}

#Preview {
    NavigationStack {
        ThemeSwitcherView()
            .themed(ThemeManager())
    }
}
