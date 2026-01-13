import SwiftUI

public struct LoadingView: View {
    let message: String?
    let isFullscreen: Bool
    
    public init(message: String? = nil, isFullscreen: Bool = false) {
        self.message = message
        self.isFullscreen = isFullscreen
    }
    
    public var body: some View {
        Group {
            if isFullscreen {
                ZStack {
                    AppColor.background.opacity(0.5).ignoresSafeArea()
                    content.padding(Spacing.l)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.m, style: .continuous))
                }
            } else { content }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(message ?? L10n.loading))
    }
    
    @ViewBuilder
    private var content: some View {
        HStack(spacing: Spacing.m) {
            ProgressView()
            Text(message ?? L10n.loading)
                .appFont(Typography.body)
                .foregroundStyle(AppColor.textPrimary)
        }
        .padding(Spacing.m)
    }
}