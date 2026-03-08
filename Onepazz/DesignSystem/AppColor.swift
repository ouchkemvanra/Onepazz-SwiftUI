import SwiftUI

// MARK: - Legacy AppColor (Deprecated)
// NOTE: This enum is deprecated. Use @Environment(\.theme) in your views instead.
// Example: @Environment(\.theme) var theme; Color(theme.colors.primary)

public enum AppColor {
    // DEPRECATED: Use theme.colors.background instead
    @available(*, deprecated, message: "Use @Environment(\\.theme) var theme; Color(theme.colors.background)")
    public static var background: Color {
        Color(uiColor: .systemBackground)
    }

    // DEPRECATED: Use theme.colors.textPrimary instead
    @available(*, deprecated, message: "Use @Environment(\\.theme) var theme; Color(theme.colors.textPrimary)")
    public static var textPrimary: Color {
        Color(uiColor: .label)
    }

    // DEPRECATED: Use theme.colors.textSecondary instead
    @available(*, deprecated, message: "Use @Environment(\\.theme) var theme; Color(theme.colors.textSecondary)")
    public static var textSecondary: Color {
        Color(uiColor: .secondaryLabel)
    }

    // DEPRECATED: Use theme.colors.accent instead
    @available(*, deprecated, message: "Use @Environment(\\.theme) var theme; Color(theme.colors.accent)")
    public static var accent: Color {
        Color(uiColor: .systemBlue)
    }

    // DEPRECATED: Use theme.colors.error instead
    @available(*, deprecated, message: "Use @Environment(\\.theme) var theme; Color(theme.colors.error)")
    public static var error: Color {
        Color(uiColor: .systemRed)
    }

    // DEPRECATED: Use theme.colors.success instead
    @available(*, deprecated, message: "Use @Environment(\\.theme) var theme; Color(theme.colors.success)")
    public static var success: Color {
        Color(uiColor: .systemGreen)
    }
}
