import UIKit
import Foundation
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
