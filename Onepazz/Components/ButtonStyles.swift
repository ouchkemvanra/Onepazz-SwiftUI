import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, Spacing.s)
            .padding(.horizontal, Spacing.l)
            .background(AppColor.accent)
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: Radius.m, style: .continuous))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

public struct SecondaryButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, Spacing.s)
            .padding(.horizontal, Spacing.l)
            .background(Color.gray.opacity(0.15))
            .foregroundStyle(AppColor.textPrimary)
            .clipShape(RoundedRectangle(cornerRadius: Radius.m, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1.0)
    }
}

public struct DestructiveButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, Spacing.s)
            .padding(.horizontal, Spacing.l)
            .background(AppColor.error.opacity(0.15))
            .foregroundStyle(AppColor.error)
            .clipShape(RoundedRectangle(cornerRadius: Radius.m, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1.0)
    }
}