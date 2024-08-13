import UIKit
import SwiftUI

struct FirstCellItem: Equatable {
    static func == (lhs: FirstCellItem, rhs: FirstCellItem) -> Bool {
        true
    }

    var itemSelected: () -> Void
}

final class FirstCell: UICollectionViewCell {
    func render(with item: FirstCellItem) {
        contentConfiguration = UIHostingConfiguration(content: {
            Button("Show") {
                item.itemSelected()
            }
        })
    }
}

struct ImageCellItem: Equatable {
    static func == (lhs: ImageCellItem, rhs: ImageCellItem) -> Bool {
        lhs.url == rhs.url
    }

    let url: URL
    let imageDisplayStorage: ImageDisplayStorage
}

final class ImageCell: UICollectionViewCell {
    func render(with item: ImageCellItem) {
        contentConfiguration = UIHostingConfiguration(content: {
            ThumbnailImageView(
                viewModel: .init(
                    url: item.url,
                    dependency: .default(imageDisplayStorage: item.imageDisplayStorage)
                )
            )
        })
    }
}

struct ImageCollectionViewData {
    var imageURLs = DummyImages.imageURLs
}

final class ImageCollectionViewModel {
    struct Dependency {
        var imageDisplayStorage: ImageDisplayStorage

        static func `default`(imageDisplayStorage: ImageDisplayStorage) -> Dependency {
            Dependency(imageDisplayStorage: imageDisplayStorage)
        }
    }

    var imageDisplayStorage: ImageDisplayStorage {
        dependency.imageDisplayStorage
    }

    var viewData: ImageCollectionViewData = .init() {
        didSet {
            didChange?()
        }
    }

    var didChange: (() -> Void)?

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency

//        dependency.imageDisplayStorage.didChange = { [weak self] url, state in
//            self?.didChange?()
//        }
    }
}

final class ImageCollectionViewController: UICollectionViewController {
    let imageCellRegistration: UICollectionView.CellRegistration<ImageCell, ImageCellItem>
    let firstCellRegistration: UICollectionView.CellRegistration<FirstCell, FirstCellItem>

    let viewModel: ImageCollectionViewModel

    private let layout = UICollectionViewCompositionalLayout.init(
        section: .init(
            group: .horizontal(
                layoutSize: .init(widthDimension: .estimated(120), heightDimension: .estimated(120)),
                subitems: [
                    .init(
                        layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(120))
                    ),
                    .init(
                        layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(120))
                    ),
                    .init(
                        layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(120))
                    ),
                ]
            )
        )
    )

    init(viewModel: ImageCollectionViewModel) {
        self.viewModel = viewModel
        self.imageCellRegistration = UICollectionView.CellRegistration<ImageCell, ImageCellItem> { cell, indexPath, item in
            cell.render(with: item)
        }

        self.firstCellRegistration = UICollectionView.CellRegistration<FirstCell, FirstCellItem> { cell, indexPath, item in
            cell.render(with: item)
        }

        super.init(collectionViewLayout: self.layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.didChange = { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: 1
        default: viewModel.viewData.imageURLs.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return collectionView.dequeueConfiguredReusableCell(
                using: firstCellRegistration,
                for: indexPath,
                item: FirstCellItem(itemSelected: { [weak self] in
                    guard let me = self else { return }
                    let sceneDelegate = me.view.window?.windowScene?.delegate as! SceneDelegate
                    let rootController = sceneDelegate.window?.rootViewController
                    let controller = UIHostingController(rootView: ImageListScreen(viewModel: ImageListViewModel(
                        dependency: .default(imageDisplayStorage: me.viewModel.imageDisplayStorage)
                    )))
                    rootController?.present(controller, animated: true)
                })
            )
        default:
            return collectionView.dequeueConfiguredReusableCell(
                using: imageCellRegistration,
                for: indexPath,
                item: ImageCellItem(
                    url: viewModel.viewData.imageURLs[indexPath.row],
                    imageDisplayStorage: viewModel.imageDisplayStorage
                )
            )
        }
    }
}

#Preview {
    ImageCollectionViewController(viewModel: .init(dependency: .default(imageDisplayStorage: ImageDisplayStorage())))
}
