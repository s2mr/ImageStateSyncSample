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
