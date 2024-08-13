import Foundation
import Combine

@MainActor
final class ThumbnailImageViewModel: ObservableObject {
    struct Dependency {
        let imageDisplayStorage: ImageDisplayStorage
        let imageLoader: ImageLoader

        static func `default`(imageDisplayStorage: ImageDisplayStorage) -> Dependency {
            Dependency(
                imageDisplayStorage: imageDisplayStorage,
                imageLoader: ImageLoader()
            )
        }
    }

    @Published var viewData: ThumbnailImageViewData
    private let dependency: Dependency
    private var cancellable: AnyCancellable?

    init(
        index: Int,
        url: URL,
        dependency: Dependency
    ) {
        _viewData = .init(
            initialValue: ThumbnailImageViewData(
                index: index,
                url: url,
                loadState: .unloaded
            )
        )
        self.dependency = dependency

        cancellable = dependency.imageDisplayStorage.didChange
            .sink { [weak self] (url, state) in
                guard let me = self else { return }

                print(me.viewData.url, url, state)
                guard me.viewData.url == url else { return }

                guard !state.isEqual(to: me.viewData.loadState) else { return }
                Task { await self?.onAppear() }
            }
    }

    func onAppear() async {
        switch dependency.imageDisplayStorage.getState(for: viewData.url) {
        case .loaded:
            let image = await dependency.imageLoader.loadImage(url: viewData.url)
            viewData.loadState = .loaded(image)

        case .mosaic:
            let image = await dependency.imageLoader.loadImage(url: viewData.url)
            viewData.loadState = .mosaic(image)

        case .unloaded:
            break
        }
    }

    func load() async {
        let image = await dependency.imageLoader.loadImage(url: viewData.url)
        viewData.loadState = .mosaic(image)
        dependency.imageDisplayStorage.set(for: viewData.url, state: .mosaic)
    }

    func removeMosaic() {
        guard case .mosaic(let image) = viewData.loadState else { return }
        viewData.loadState = .loaded(image)
        dependency.imageDisplayStorage.set(for: viewData.url, state: .loaded)
    }
}
