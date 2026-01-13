import UIKit
import Combine

final class GymsViewController: BaseViewController<GymsUIKitViewModel, ViewState<[Gym]>, GymsInput>, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var data: [Gym] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gyms"
        setupTable()
        // Trigger first load
        (viewModel).input.send(.reload)
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Render
    override func render(state: ViewState<[Gym]>) {
        switch state {
        case .idle:
            setLoading(false)
        case .loading:
            setLoading(true)
        case .loaded(let gyms):
            setLoading(false)
            data = gyms
            tableView.reloadData()
        case .empty:
            setLoading(false)
            data = []
            tableView.reloadData()
        case .failed(let err):
            setLoading(false)
            showError(err.localizedDescription)
        }
    }

    // MARK: - Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { data.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let gym = data[indexPath.row]
        cell.textLabel?.text = gym.name
        cell.detailTextLabel?.text = gym.city + (gym.isOpenNow ? " • Open" : " • Closed")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
