//
//  ThemeSystem.swift
//  Onepazz
//
//  Created by Claude on 2/22/26.
//  Scalable theme system supporting unlimited custom themes
//

import SwiftUI

// MARK: - Theme Configuration (Data-driven)

/// Represents a complete theme configuration
/// This is Codable so themes can be saved/loaded/shared
public struct ThemeConfiguration: Codable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let displayName: String
    public let isCustom: Bool

    // Color palette
    public let colors: ColorPalette

    // Optional: Typography overrides (uses default if nil)
    public let typography: TypographyConfig?

    // Optional: Spacing overrides (uses default if nil)
    public let spacing: SpacingConfig?

    // Optional: Radius overrides (uses default if nil)
    public let radius: RadiusConfig?

    // Optional: Shadow overrides (uses default if nil)
    public let shadows: ShadowsConfig?

    // Optional: Animation overrides (uses default if nil)
    public let animations: AnimationsConfig?

    // Optional: Icon size overrides (uses default if nil)
    public let icons: IconsConfig?

    public init(
        id: String,
        name: String,
        displayName: String,
        isCustom: Bool = false,
        colors: ColorPalette,
        typography: TypographyConfig? = nil,
        spacing: SpacingConfig? = nil,
        radius: RadiusConfig? = nil,
        shadows: ShadowsConfig? = nil,
        animations: AnimationsConfig? = nil,
        icons: IconsConfig? = nil
    ) {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.isCustom = isCustom
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.radius = radius
        self.shadows = shadows
        self.animations = animations
        self.icons = icons
    }
}

// MARK: - Color Palette

public struct ColorPalette: Codable, Equatable {
    // Primary
    public let primary: CodableColor
    public let primaryVariant: CodableColor
    public let onPrimary: CodableColor

    // Secondary
    public let secondary: CodableColor
    public let secondaryVariant: CodableColor
    public let onSecondary: CodableColor

    // Background
    public let background: CodableColor
    public let surface: CodableColor
    public let surfaceVariant: CodableColor

    // Text
    public let textPrimary: CodableColor
    public let textSecondary: CodableColor
    public let textTertiary: CodableColor
    public let textInverse: CodableColor

    // Semantic
    public let accent: CodableColor
    public let error: CodableColor
    public let warning: CodableColor
    public let success: CodableColor
    public let info: CodableColor

    // Overlay
    public let overlay: CodableColor
    public let scrim: CodableColor

    // Border
    public let border: CodableColor
    public let divider: CodableColor

    // Brand
    public let brandPrimary: CodableColor
    public let brandSecondary: CodableColor
    public let brandAccent: CodableColor

    // Card
    public let card: CodableColor
    public let cardHighlight: CodableColor
}

// MARK: - Codable Color (Helper to save colors)

public struct CodableColor: Codable, Equatable {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let opacity: Double

    public init(red: Double, green: Double, blue: Double, opacity: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }

    public init(from color: Color) {
        // Extract RGB from Color (simplified - in production use UIColor)
        self.red = 0.5
        self.green = 0.5
        self.blue = 0.5
        self.opacity = 1.0
    }

    public var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - Configuration Structs

public struct TypographyConfig: Codable, Equatable {
    public let largeTitle: FontConfig
    public let title1: FontConfig
    public let title2: FontConfig
    public let title3: FontConfig
    public let headline: FontConfig
    public let body: FontConfig
    public let subhead: FontConfig
    public let footnote: FontConfig
    public let caption: FontConfig
}

public struct FontConfig: Codable, Equatable {
    public let size: CGFloat
    public let weight: String // "bold", "semibold", "regular", etc.
    public let design: String // "default", "rounded", "monospaced"
}

public struct SpacingConfig: Codable, Equatable {
    public let xs: CGFloat
    public let s: CGFloat
    public let m: CGFloat
    public let l: CGFloat
    public let xl: CGFloat
    public let xxl: CGFloat
}

public struct RadiusConfig: Codable, Equatable {
    public let xs: CGFloat
    public let s: CGFloat
    public let m: CGFloat
    public let l: CGFloat
    public let xl: CGFloat
}

public struct ShadowsConfig: Codable, Equatable {
    public let small: ShadowConfig
    public let medium: ShadowConfig
    public let large: ShadowConfig
}

public struct ShadowConfig: Codable, Equatable {
    public let color: CodableColor
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
}

public struct AnimationsConfig: Codable, Equatable {
    public let fast: Double
    public let normal: Double
    public let slow: Double
    public let springResponse: Double
    public let springDamping: Double
}

public struct IconsConfig: Codable, Equatable {
    public let small: CGFloat
    public let medium: CGFloat
    public let large: CGFloat
    public let xLarge: CGFloat
}

// MARK: - Theme Presets

public enum ThemePresets {
    /// Built-in light theme
    public static let light = ThemeConfiguration(
        id: "light",
        name: "light",
        displayName: "Light",
        colors: ColorPalette(
            primary: CodableColor(red: 0.15, green: 0.24, blue: 0.29),
            primaryVariant: CodableColor(red: 0.2, green: 0.3, blue: 0.4),
            onPrimary: CodableColor(red: 1, green: 1, blue: 1),
            secondary: CodableColor(red: 0.4, green: 0.73, blue: 0.82),
            secondaryVariant: CodableColor(red: 0, green: 1, blue: 1),
            onSecondary: CodableColor(red: 0, green: 0, blue: 0),
            background: CodableColor(red: 1, green: 1, blue: 1),
            surface: CodableColor(red: 0.95, green: 0.95, blue: 0.97),
            surfaceVariant: CodableColor(red: 0.92, green: 0.92, blue: 0.94),
            textPrimary: CodableColor(red: 0, green: 0, blue: 0),
            textSecondary: CodableColor(red: 0.24, green: 0.24, blue: 0.26, opacity: 0.6),
            textTertiary: CodableColor(red: 0.24, green: 0.24, blue: 0.26, opacity: 0.3),
            textInverse: CodableColor(red: 1, green: 1, blue: 1),
            accent: CodableColor(red: 0.2, green: 0.6, blue: 0.86),
            error: CodableColor(red: 1, green: 0.23, blue: 0.19),
            warning: CodableColor(red: 1, green: 0.58, blue: 0),
            success: CodableColor(red: 0.2, green: 0.78, blue: 0.35),
            info: CodableColor(red: 0, green: 0.48, blue: 1),
            overlay: CodableColor(red: 0, green: 0, blue: 0, opacity: 0.5),
            scrim: CodableColor(red: 0, green: 0, blue: 0, opacity: 0.75),
            border: CodableColor(red: 0, green: 0, blue: 0, opacity: 0.06),
            divider: CodableColor(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3),
            brandPrimary: CodableColor(red: 0.3, green: 0.5, blue: 0.6),
            brandSecondary: CodableColor(red: 0, green: 1, blue: 1),
            brandAccent: CodableColor(red: 1, green: 1, blue: 0),
            card: CodableColor(red: 0.95, green: 0.95, blue: 0.97),
            cardHighlight: CodableColor(red: 0, green: 1, blue: 1, opacity: 0.2)
        )
    )

    /// Built-in dark theme
    public static let dark = ThemeConfiguration(
        id: "dark",
        name: "dark",
        displayName: "Dark",
        colors: ColorPalette(
            primary: CodableColor(red: 0.85, green: 0.85, blue: 0.87),
            primaryVariant: CodableColor(red: 0.7, green: 0.7, blue: 0.75),
            onPrimary: CodableColor(red: 0, green: 0, blue: 0),
            secondary: CodableColor(red: 0.5, green: 0.8, blue: 0.9),
            secondaryVariant: CodableColor(red: 0, green: 1, blue: 1),
            onSecondary: CodableColor(red: 0, green: 0, blue: 0),
            background: CodableColor(red: 0, green: 0, blue: 0),
            surface: CodableColor(red: 0.11, green: 0.11, blue: 0.12),
            surfaceVariant: CodableColor(red: 0.17, green: 0.17, blue: 0.18),
            textPrimary: CodableColor(red: 1, green: 1, blue: 1),
            textSecondary: CodableColor(red: 0.92, green: 0.92, blue: 0.96, opacity: 0.6),
            textTertiary: CodableColor(red: 0.92, green: 0.92, blue: 0.96, opacity: 0.3),
            textInverse: CodableColor(red: 0, green: 0, blue: 0),
            accent: CodableColor(red: 0.3, green: 0.7, blue: 0.9),
            error: CodableColor(red: 1, green: 0.27, blue: 0.23),
            warning: CodableColor(red: 1, green: 0.62, blue: 0.04),
            success: CodableColor(red: 0.2, green: 0.84, blue: 0.29),
            info: CodableColor(red: 0.04, green: 0.52, blue: 1),
            overlay: CodableColor(red: 0, green: 0, blue: 0, opacity: 0.6),
            scrim: CodableColor(red: 0, green: 0, blue: 0, opacity: 0.85),
            border: CodableColor(red: 1, green: 1, blue: 1, opacity: 0.1),
            divider: CodableColor(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.4),
            brandPrimary: CodableColor(red: 0.4, green: 0.6, blue: 0.7),
            brandSecondary: CodableColor(red: 0, green: 1, blue: 1),
            brandAccent: CodableColor(red: 1, green: 1, blue: 0),
            card: CodableColor(red: 0.11, green: 0.11, blue: 0.12),
            cardHighlight: CodableColor(red: 0, green: 1, blue: 1, opacity: 0.15)
        )
    )

    /// Example: Ocean theme
    public static let ocean = ThemeConfiguration(
        id: "ocean",
        name: "ocean",
        displayName: "Ocean",
        isCustom: true,
        colors: ColorPalette(
            primary: CodableColor(red: 0.0, green: 0.4, blue: 0.6),
            primaryVariant: CodableColor(red: 0.0, green: 0.3, blue: 0.5),
            onPrimary: CodableColor(red: 1, green: 1, blue: 1),
            secondary: CodableColor(red: 0.0, green: 0.7, blue: 0.8),
            secondaryVariant: CodableColor(red: 0.0, green: 0.6, blue: 0.7),
            onSecondary: CodableColor(red: 1, green: 1, blue: 1),
            background: CodableColor(red: 0.94, green: 0.97, blue: 0.99),
            surface: CodableColor(red: 1, green: 1, blue: 1),
            surfaceVariant: CodableColor(red: 0.97, green: 0.99, blue: 1),
            textPrimary: CodableColor(red: 0.1, green: 0.2, blue: 0.3),
            textSecondary: CodableColor(red: 0.3, green: 0.4, blue: 0.5),
            textTertiary: CodableColor(red: 0.5, green: 0.6, blue: 0.7),
            textInverse: CodableColor(red: 1, green: 1, blue: 1),
            accent: CodableColor(red: 0.0, green: 0.5, blue: 0.7),
            error: CodableColor(red: 0.9, green: 0.2, blue: 0.2),
            warning: CodableColor(red: 1, green: 0.6, blue: 0),
            success: CodableColor(red: 0.2, green: 0.8, blue: 0.4),
            info: CodableColor(red: 0.0, green: 0.6, blue: 0.9),
            overlay: CodableColor(red: 0, green: 0.2, blue: 0.3, opacity: 0.5),
            scrim: CodableColor(red: 0, green: 0.1, blue: 0.2, opacity: 0.7),
            border: CodableColor(red: 0.0, green: 0.4, blue: 0.6, opacity: 0.2),
            divider: CodableColor(red: 0.0, green: 0.5, blue: 0.7, opacity: 0.2),
            brandPrimary: CodableColor(red: 0.0, green: 0.4, blue: 0.6),
            brandSecondary: CodableColor(red: 0.0, green: 0.7, blue: 0.8),
            brandAccent: CodableColor(red: 1, green: 0.8, blue: 0.2),
            card: CodableColor(red: 1, green: 1, blue: 1),
            cardHighlight: CodableColor(red: 0.0, green: 0.7, blue: 0.8, opacity: 0.1)
        )
    )

    /// All built-in themes
    public static let all: [ThemeConfiguration] = [light, dark, ocean]
}
