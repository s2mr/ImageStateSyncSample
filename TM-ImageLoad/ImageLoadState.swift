import UIKit

enum ImageLoadState {
    case loaded(UIImage)
    case mosaic(UIImage)
    case unloaded
}
