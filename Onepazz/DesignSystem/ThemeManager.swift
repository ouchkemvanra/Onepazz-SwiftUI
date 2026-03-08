import SwiftUI

// MARK: - Theme Manager

/// Manages theme selection and switching
/// Supports unlimited custom themes through ThemeRegistry
public final class ThemeManager: ObservableObject {
    // MARK: - Published Properties

    @Published public private(set) var currentTheme: ThemeConfiguration {
        didSet {
            saveCurrentTheme()
        }
    }

    @Published public private(set) var availableThemes: [ThemeConfiguration]

    // MARK: - Private Properties

    private let registry: ThemeRegistry
    private let userDefaults: UserDefaults

    private static let currentThemeKey = "app.theme.current"
    private static let customThemesKey = "app.theme.custom"

    // MARK: - Initialization

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        let registry = ThemeRegistry()
        self.registry = registry

        // Load custom themes from UserDefaults
        if let customThemesData = userDefaults.data(forKey: Self.customThemesKey),
           let customThemes = try? JSONDecoder().decode([ThemeConfiguration].self, from: customThemesData) {
            customThemes.forEach { registry.register($0) }
        }

        // Load current theme (or use default)
        if let savedThemeID = userDefaults.string(forKey: Self.currentThemeKey),
           let savedTheme = registry.theme(withID: savedThemeID) {
            self.currentTheme = savedTheme
        } else {
            // Default to system theme (light/dark based on system)
            self.currentTheme = Self.systemTheme()
        }

        self.availableThemes = registry.allThemes()
    }

    // MARK: - Public Methods

    /// Switch to a theme by ID
    public func setTheme(id: String) {
        guard let theme = registry.theme(withID: id) else {
            print("⚠️ Theme with ID '\(id)' not found")
            return
        }
        currentTheme = theme
    }

    /// Switch to a theme configuration
    public func setTheme(_ theme: ThemeConfiguration) {
        // Register if not already registered
        if registry.theme(withID: theme.id) == nil {
            registry.register(theme)
            availableThemes = registry.allThemes()
        }
        currentTheme = theme
    }

    /// Add a custom theme
    public func addCustomTheme(_ theme: ThemeConfiguration) {
        registry.register(theme)
        availableThemes = registry.allThemes()
        saveCustomThemes()
    }

    /// Remove a custom theme
    public func removeCustomTheme(id: String) {
        registry.unregister(id: id)
        availableThemes = registry.allThemes()
        saveCustomThemes()

        // If current theme was removed, switch to light theme
        if currentTheme.id == id {
            setTheme(id: "light")
        }
    }

    /// Get theme by ID
    public func theme(withID id: String) -> ThemeConfiguration? {
        registry.theme(withID: id)
    }

    // MARK: - Convenience Properties

    /// Current theme colors
    public var colors: ColorPalette {
        currentTheme.colors
    }

    /// Current theme typography (with fallback to default)
    public var typography: TypographyConfig {
        currentTheme.typography ?? TypographyConfig.default
    }

    /// Current theme spacing (with fallback to default)
    public var spacing: SpacingConfig {
        currentTheme.spacing ?? SpacingConfig.default
    }

    /// Current theme radius (with fallback to default)
    public var radius: RadiusConfig {
        currentTheme.radius ?? RadiusConfig.default
    }

    /// Current theme shadows (with fallback to default)
    public var shadows: ShadowsConfig {
        currentTheme.shadows ?? ShadowsConfig.default
    }

    /// Current theme animations (with fallback to default)
    public var animations: AnimationsConfig {
        currentTheme.animations ?? AnimationsConfig.default
    }

    /// Current theme icons (with fallback to default)
    public var icons: IconsConfig {
        currentTheme.icons ?? IconsConfig.default
    }

    // MARK: - Private Methods

    private func saveCurrentTheme() {
        userDefaults.set(currentTheme.id, forKey: Self.currentThemeKey)
    }

    private func saveCustomThemes() {
        let customThemes = registry.allThemes().filter { $0.isCustom }
        if let encoded = try? JSONEncoder().encode(customThemes) {
            userDefaults.set(encoded, forKey: Self.customThemesKey)
        }
    }

    private static func systemTheme() -> ThemeConfiguration {
        // Check system appearance
        let isDark = UITraitCollection.current.userInterfaceStyle == .dark
        return isDark ? ThemePresets.dark : ThemePresets.light
    }
}

// MARK: - Theme Registry

/// Registry for managing available themes
private class ThemeRegistry {
    private var themes: [String: ThemeConfiguration] = [:]

    init() {
        // Register built-in themes
        ThemePresets.all.forEach { register($0) }
    }

    func register(_ theme: ThemeConfiguration) {
        themes[theme.id] = theme
    }

    func unregister(id: String) {
        themes.removeValue(forKey: id)
    }

    func theme(withID id: String) -> ThemeConfiguration? {
        themes[id]
    }

    func allThemes() -> [ThemeConfiguration] {
        Array(themes.values).sorted { $0.displayName < $1.displayName }
    }
}

// MARK: - Default Configurations

extension TypographyConfig {
    public static let `default` = TypographyConfig(
        largeTitle: FontConfig(size: 34, weight: "bold", design: "default"),
        title1: FontConfig(size: 28, weight: "semibold", design: "default"),
        title2: FontConfig(size: 22, weight: "semibold", design: "default"),
        title3: FontConfig(size: 20, weight: "semibold", design: "default"),
        headline: FontConfig(size: 17, weight: "semibold", design: "default"),
        body: FontConfig(size: 17, weight: "regular", design: "default"),
        subhead: FontConfig(size: 15, weight: "regular", design: "default"),
        footnote: FontConfig(size: 13, weight: "regular", design: "default"),
        caption: FontConfig(size: 12, weight: "regular", design: "default")
    )
}

extension SpacingConfig {
    public static let `default` = SpacingConfig(
        xs: 4, s: 8, m: 12, l: 16, xl: 24, xxl: 32
    )
}

extension RadiusConfig {
    public static let `default` = RadiusConfig(
        xs: 4, s: 8, m: 12, l: 20, xl: 28
    )
}

extension ShadowsConfig {
    public static let `default` = ShadowsConfig(
        small: ShadowConfig(
            color: CodableColor(red: 0, green: 0, blue: 0, opacity: 0.04),
            radius: 4, x: 0, y: 2
        ),
        medium: ShadowConfig(
            color: CodableColor(red: 0, green: 0, blue: 0, opacity: 0.08),
            radius: 8, x: 0, y: 4
        ),
        large: ShadowConfig(
            color: CodableColor(red: 0, green: 0, blue: 0, opacity: 0.12),
            radius: 16, x: 0, y: 8
        )
    )
}

extension AnimationsConfig {
    public static let `default` = AnimationsConfig(
        fast: 0.2,
        normal: 0.3,
        slow: 0.5,
        springResponse: 0.3,
        springDamping: 0.7
    )
}

extension IconsConfig {
    public static let `default` = IconsConfig(
        small: 16,
        medium: 24,
        large: 32,
        xLarge: 48
    )
}
    
