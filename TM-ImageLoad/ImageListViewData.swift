import Foundation

struct ImageListViewData {
    var imageURLs: [URL] = DummyImages.imageURLs
    var imageDisplayStates: [URL: ImageDisplayState] = [:]
}
