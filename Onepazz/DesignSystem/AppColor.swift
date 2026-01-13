import SwiftUI

public enum AppColor {
    // Use system colors with proper fallbacks
    public static var background: Color {
        Color(uiColor: .systemBackground)
    }

    public static var textPrimary: Color {
        Color(uiColor: .label)
    }

    public static var textSecondary: Color {
        Color(uiColor: .secondaryLabel)
    }

    public static var accent: Color {
        Color(uiColor: .systemBlue)
    }

    public static var error: Color {
        Color(uiColor: .systemRed)
    }

    public static var success: Color {
        Color(uiColor: .systemGreen)
    }
}
