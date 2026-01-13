import UIKit
import Combine

/// A UIKit base controller that binds to a BaseViewModel's state.
class BaseViewController<VM, State, Input>: UIViewController {
    let viewModel: VM
    var cancellables = Set<AnyCancellable>()

    // Simple loading overlay
    private lazy var loadingView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThinMaterial)
        let v = UIVisualEffectView(effect: blur)
        v.layer.cornerRadius = 12
        v.clipsToBounds = true
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        v.contentView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: v.contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: v.contentView.centerYAnchor)
        ])
        v.isHidden = true
        return v
    }()

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupLoadingOverlay()
        bindState()
    }

    func bindState() {
        // Expect VM to be BaseViewModel<...>. We downcast safely for a generic binding.
        guard let vm = viewModel as? BaseViewModel<State, Input> else { return }
        vm.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state: state)
            }
            .store(in: &cancellables)
    }

    /// Override to react to state changes
    func render(state: State) {
        // subclasses implement
    }

    // MARK: - Loading overlay
    private func setupLoadingOverlay() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 160),
            loadingView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    func setLoading(_ visible: Bool) {
        loadingView.isHidden = !visible
    }

    func showError(_ message: String, title: String = "Error") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}