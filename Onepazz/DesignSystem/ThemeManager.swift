import SwiftUI

    public final class ThemeManager: ObservableObject {
        public struct Palette {
            public var accent: Color = AppColor.accent
        }
        @Published public var palette = Palette()
    }
    