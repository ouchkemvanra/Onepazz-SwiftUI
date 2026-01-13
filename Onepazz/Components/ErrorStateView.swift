import SwiftUI

public struct ErrorStateView: View {
    let title: String
    let message: String
    let retryTitle: String
    let onRetry: () -> Void
    
    public init(title: String = L10n.error, message: String, retryTitle: String = L10n.tryAgain, onRetry: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.onRetry = onRetry
    }
    
    public var body: some View {
        VStack(spacing: Spacing.m) {
            Image(systemName: "xmark.octagon")
                .font(.system(size: 40, weight: .regular))
                .foregroundStyle(AppColor.error)
            Text(title).appFont(Typography.title2)
                .foregroundStyle(AppColor.textPrimary)
            Text(message).appFont(Typography.subhead)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
            Button(retryTitle, action: onRetry)
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding(Spacing.xl)
    }
}