//
//  ThemeExtensions.swift
//  Onepazz
//
//  Created by Claude on 2/22/26.
//

import SwiftUI

// MARK: - Environment Key

private struct ThemeManagerKey: EnvironmentKey {
    static let defaultValue: ThemeManager = ThemeManager()
}

extension EnvironmentValues {
    public var theme: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {
    /// Inject ThemeManager into environment
    public func themed(_ themeManager: ThemeManager) -> some View {
        self.environment(\.theme, themeManager)
    }
}

// MARK: - Color Extensions

extension Color {
    /// Create color from CodableColor
    public init(_ codable: CodableColor) {
        self.init(red: codable.red, green: codable.green, blue: codable.blue, opacity: codable.opacity)
    }
}

// MARK: - Shadow Extension

extension View {
    /// Apply themed shadow
    public func themedShadow(_ shadow: ShadowConfig) -> some View {
        self.shadow(
            color: Color(shadow.color),
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}

// MARK: - Theme-Aware View Modifiers

/// Apply primary button style using theme
public struct ThemedPrimaryButtonStyle: ButtonStyle {
    @Environment(\.theme) var theme

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, theme.spacing.s)
            .padding(.horizontal, theme.spacing.l)
            .background(Color(theme.colors.primary))
            .foregroundStyle(Color(theme.colors.onPrimary))
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.m, style: .continuous))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

/// Apply secondary button style using theme
public struct ThemedSecondaryButtonStyle: ButtonStyle {
    @Environment(\.theme) var theme

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, theme.spacing.s)
            .padding(.horizontal, theme.spacing.l)
            .background(Color(theme.colors.surface))
            .foregroundStyle(Color(theme.colors.textPrimary))
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.m, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1.0)
    }
}

/// Apply card style using theme
public struct ThemedCardModifier: ViewModifier {
    @Environment(\.theme) var theme
    let highlighted: Bool

    public func body(content: Content) -> some View {
        content
            .background(Color(highlighted ? theme.colors.cardHighlight : theme.colors.card))
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.l, style: .continuous))
            .themedShadow(theme.shadows.medium)
    }
}

extension View {
    public func themedCard(highlighted: Bool = false) -> some View {
        self.modifier(ThemedCardModifier(highlighted: highlighted))
    }
}

// MARK: - Typography Helpers

extension Font {
    public static func themed(_ fontConfig: FontConfig) -> Font {
        let weight: Font.Weight = {
            switch fontConfig.weight.lowercased() {
            case "ultralight": return .ultraLight
            case "thin": return .thin
            case "light": return .light
            case "regular": return .regular
            case "medium": return .medium
            case "semibold": return .semibold
            case "bold": return .bold
            case "heavy": return .heavy
            case "black": return .black
            default: return .regular
            }
        }()

        let design: Font.Design = {
            switch fontConfig.design.lowercased() {
            case "default": return .default
            case "rounded": return .rounded
            case "monospaced": return .monospaced
            case "serif": return .serif
            default: return .default
            }
        }()

        return .system(size: fontConfig.size, weight: weight, design: design)
    }
}

// MARK: - Preset Button Styles

extension ButtonStyle where Self == ThemedPrimaryButtonStyle {
    public static var themedPrimary: ThemedPrimaryButtonStyle {
        ThemedPrimaryButtonStyle()
    }
}

extension ButtonStyle where Self == ThemedSecondaryButtonStyle {
    public static var themedSecondary: ThemedSecondaryButtonStyle {
        ThemedSecondaryButtonStyle()
    }
}
