import UIKit

protocol FlowCoordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var children: [FlowCoordinator] { get set }
    func start()
    func handle(_ deepLink: DeepLink) -> Bool
    func addChild(_ child: FlowCoordinator)
    func removeChild(_ child: FlowCoordinator)
}

extension FlowCoordinator {
    func addChild(_ child: FlowCoordinator) {
        children.append(child)
    }
    func removeChild(_ child: FlowCoordinator) {
        children.removeAll { $0 === child }
    }
}

enum DeepLink {
    case gyms
    case subscriptions
    case login(email: String?)
    case unknown
}

final class RootFlowCoordinator: FlowCoordinator {
    let navigationController: UINavigationController
    var children: [FlowCoordinator] = []

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        navigationController.view.backgroundColor = .systemBackground
    }

    func start() {
        // Default flow: go to gyms
        _ = handle(.gyms)
    }

    @discardableResult
    func handle(_ deepLink: DeepLink) -> Bool {
        switch deepLink {
        case .gyms:
            let api = APIManager()
            let repo = GymsRepository(api: api)
            let vm = GymsUIKitViewModel(repo: repo)
            let vc = GymsViewController(viewModel: vm)
            vc.title = L10n.gymsTitle
            navigationController.setViewControllers([vc], animated: false)
            return true
        case .subscriptions:
            // Placeholder SwiftUI hosting to demonstrate another destination
            let vc = Hosting.controller { SubscriptionsView() }
            navigationController.pushViewController(vc, animated: true)
            return true
        case .login(let email):
            let vc = Hosting.controller {
                LoginView()
                    .onAppear {
                        // If you'd like to pre-fill email, you can expose an env or pass through VM
                        print("Prefill email: \(email ?? "nil")")
                    }
            }
            navigationController.present(vc, animated: true)
            return true
        case .unknown:
            return false
        }
    }
}