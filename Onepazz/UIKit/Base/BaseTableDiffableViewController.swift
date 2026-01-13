import UIKit
import Combine

/// A UITableView base VC with Diffable Data Source and MVVM state binding.
class BaseTableDiffableViewController<VM, State, Input, Section: Hashable, Item: Hashable>:
    BaseViewController<VM, State, Input>, UITableViewDelegate {

    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        dataSource = makeDataSource()
    }

    func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    /// Override to create and return a configured data source
    func makeDataSource() -> DataSource {
        return DataSource(tableView: tableView) { tableView, indexPath, item in
            // Default cell; subclasses should override for custom cell configs
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ??
                UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = "\(item)"
            return cell
        }
    }

    /// Apply a snapshot (call from render(state:))
    func apply(_ snapshot: Snapshot, animatingDifferences: Bool = true) {
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}