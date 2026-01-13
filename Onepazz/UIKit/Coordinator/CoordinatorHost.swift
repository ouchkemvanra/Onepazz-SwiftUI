import SwiftUI
import UIKit

struct CoordinatorHost: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let coordinator = RootFlowCoordinator()
        let nav = coordinator.navigationController
        coordinator.start()
        return nav
    }
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}