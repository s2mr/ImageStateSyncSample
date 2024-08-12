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

struct ImageCellItem: Hashable {
    var url: URL
}

final class ImageCell: UICollectionViewCell {
    func render(with item: ImageCellItem) {
        contentConfiguration = UIHostingConfiguration(content: {
            ThumbnailImageView(url: item.url)
        })
    }
}

final class ImageCollectionViewController: UICollectionViewController {
    let imageCellRegistration: UICollectionView.CellRegistration<ImageCell, ImageCellItem>
    let firstCellRegistration: UICollectionView.CellRegistration<FirstCell, FirstCellItem>

    let imageURLs = DummyImages.imageURLs

    init() {
        self.imageCellRegistration = UICollectionView.CellRegistration<ImageCell, ImageCellItem> { cell, indexPath, item in
            cell.render(with: item)
        }

        self.firstCellRegistration = UICollectionView.CellRegistration<FirstCell, FirstCellItem> { cell, indexPath, item in
            cell.render(with: item)
        }

        super.init(
            collectionViewLayout: UICollectionViewCompositionalLayout.init(
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
        )
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
        default: imageURLs.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            collectionView.dequeueConfiguredReusableCell(using: firstCellRegistration, for: indexPath, item: FirstCellItem(itemSelected: { [weak self] in
                let sceneDelegate = self?.view.window?.windowScene?.delegate as! SceneDelegate
                let rootController = sceneDelegate.window?.rootViewController
                let controller = UIHostingController(rootView: ImageListScreen())
                rootController?.present(controller, animated: true)

            }))
        default:
            collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: ImageCellItem(url: imageURLs[indexPath.row]))
        }
    }
}

#Preview {
    ImageCollectionViewController()
}
