import UIKit
import Foundation
import SwiftUI

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
