import UIKit
import Combine

/// A UICollectionView base VC with Diffable Data Source and MVVM state binding.
class BaseCollectionDiffableViewController<VM, State, Input, Section: Hashable, Item: Hashable>:
    BaseViewController<VM, State, Input>, UICollectionViewDelegate {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    let collectionView: UICollectionView
    var dataSource: DataSource!

    init(viewModel: VM, layout: UICollectionViewLayout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        dataSource = makeDataSource()
    }

    func setupCollection() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Default registration
        let reg = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, item in
            var cfg = cell.defaultContentConfiguration()
            cfg.text = "\(item)"
            cell.contentConfiguration = cfg
        }
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: reg, for: indexPath, item: item)
        }
    }

    /// Override if you need a custom data source setup
    func makeDataSource() -> DataSource {
        return dataSource
    }

    func apply(_ snapshot: Snapshot, animatingDifferences: Bool = true) {
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}