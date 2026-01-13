import SwiftUI

public struct LoadingOverlay: ViewModifier {
    @Binding var isPresented: Bool
    let message: String?
    
    public init(isPresented: Binding<Bool>, message: String? = nil) {
        self._isPresented = isPresented
        self.message = message
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                LoadingView(message: message, isFullscreen: true)
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut(duration: 0.2), value: isPresented)
            }
        }
    }
}

public extension View {
    func loadingOverlay(_ isPresented: Binding<Bool>, message: String? = nil) -> some View {
        modifier(LoadingOverlay(isPresented: isPresented, message: message))
    }
}