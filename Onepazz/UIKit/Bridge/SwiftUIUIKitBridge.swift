import SwiftUI
import UIKit

// MARK: - UIKit -> SwiftUI
/// Wrap any UIViewController in SwiftUI
struct ViewControllerRepresentable<V: UIViewController>: UIViewControllerRepresentable {
    let make: () -> V
    func makeUIViewController(context: Context) -> V { make() }
    func updateUIViewController(_ uiViewController: V, context: Context) {}
}

// MARK: - SwiftUI -> UIKit
/// Convenience hoster
final class Hosting {
    static func controller<Content: View>(@ViewBuilder _ content: () -> Content) -> UIViewController {
        UIHostingController(rootView: content())
    }
}