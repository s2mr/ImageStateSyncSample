import UIKit
import Foundation
import SwiftUI

struct ImageCellItem: Hashable {
    static func == (lhs: ImageCellItem, rhs: ImageCellItem) -> Bool {
        lhs.url == rhs.url
        && lhs.index == rhs.index
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(url)
    }

    let index: Int
    let url: URL
    let imageDisplayStorage: ImageDisplayStorage
}

final class ImageCell: UICollectionViewCell {
    func render(with item: ImageCellItem) {
        contentConfiguration = UIHostingConfiguration(content: {
            ThumbnailImageView(
                viewModel: .init(
                    index: item.index,
                    url: item.url,
                    dependency: .default(imageDisplayStorage: item.imageDisplayStorage)
                )
            )
        })
    }
}
