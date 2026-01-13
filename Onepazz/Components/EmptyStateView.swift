import SwiftUI

public struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String
    
    public init(systemImage: String = "tray", title: String, message: String) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: Spacing.s) {
            Image(systemName: systemImage)
                .font(.system(size: 36, weight: .regular))
                .foregroundStyle(AppColor.textSecondary)
            Text(title).appFont(Typography.title2)
                .foregroundStyle(AppColor.textPrimary)
            Text(message).appFont(Typography.subhead)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.xl)
    }
}