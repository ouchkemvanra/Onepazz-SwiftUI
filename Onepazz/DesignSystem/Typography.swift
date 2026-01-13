import SwiftUI

public enum Typography {
    case largeTitle, title1, title2, title3, headline, body, subhead, footnote, caption

    var font: Font {
        switch self {
        case .largeTitle: return .system(size: 34, weight: .bold, design: .default)
        case .title1:     return .system(size: 28, weight: .semibold, design: .default)
        case .title2:     return .system(size: 22, weight: .semibold, design: .default)
        case .title3:     return .system(size: 20, weight: .semibold, design: .default)
        case .headline:   return .system(size: 17, weight: .semibold, design: .default)
        case .body:       return .system(size: 17, weight: .regular, design: .default)
        case .subhead:    return .system(size: 15, weight: .regular, design: .default)
        case .footnote:   return .system(size: 13, weight: .regular, design: .default)
        case .caption:    return .system(size: 12, weight: .regular, design: .default)
        }
    }
}

public extension View {
    func appFont(_ t: Typography) -> some View { self.font(t.font) }
}