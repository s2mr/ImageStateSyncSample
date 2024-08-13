import Foundation

final class ImageListViewModel: ObservableObject {
    struct Dependency {
        var imageDisplayStorage: ImageDisplayStorage

        static func `default`(imageDisplayStorage: ImageDisplayStorage) -> Dependency {
            Dependency(imageDisplayStorage: imageDisplayStorage)
        }
    }

    var imageDisplayStorage: ImageDisplayStorage {
        dependency.imageDisplayStorage
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    @Published var viewData = ImageListViewData()
}
