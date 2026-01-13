import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
        // Example start: push the Gyms UIKit screen
        let api = APIManager()
        let repo = GymsRepository(api: api)
        let vm = GymsUIKitViewModel(repo: repo)
        let gymsVC = GymsViewController(viewModel: vm)
        gymsVC.title = L10n.gymsTitle
        navigationController.view.backgroundColor = .systemBackground
        navigationController.pushViewController(gymsVC, animated: false)
    }
}