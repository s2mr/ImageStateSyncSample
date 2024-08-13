import SwiftUI

enum DummyImages {
    static let imageURLs: [URL] = {
        (0..<20).map { number in
            URL(string: "https://placehold.jp/150x150.png?text=\(number)")!
        }
    }()
}

struct ImageListViewData {
    var imageURLs: [URL] = DummyImages.imageURLs
    var imageDisplayStates: [URL: ImageDisplayState] = [:]

    init() {

    }
}

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

final class ImageLoader {
}

enum ImageDisplayState {
    case unloaded
    case loaded
}

enum ImageLoadState {
    case loaded(UIImage)
    case mosaic(UIImage)
    case unloaded
}

struct ThumbnailImageViewData {
    var url: URL
    var loadState: ImageLoadState
}

final class ImageDisplayStorage {
    private var displayStates: [URL: ImageDisplayState] = [:] {
        didSet {
            didChange?()
        }
    }

    var didChange: (() -> Void)?

    func set(for url: URL, state: ImageDisplayState) {
        displayStates[url] = state
    }

    func getState(for url: URL) -> ImageDisplayState {
        displayStates[url] ?? .loaded
    }
}

@MainActor
final class ThumbnailImageViewModel: ObservableObject {
    struct Dependency {
        var imageDisplayStorage: ImageDisplayStorage

        static func `default`(imageDisplayStorage: ImageDisplayStorage) -> Dependency {
            Dependency(imageDisplayStorage: imageDisplayStorage)
        }
    }

    @Published var viewData: ThumbnailImageViewData
    private let dependency: Dependency

    init(url: URL, dependency: Dependency) {
        _viewData = .init(
            initialValue: ThumbnailImageViewData(url: url, loadState: .unloaded)
        )
        self.dependency = dependency

        dependency.imageDisplayStorage.didChange = { [weak self] in
            Task { await self?.load() }
        }
    }

    func load() async {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: viewData.url))
            viewData.loadState = .mosaic(UIImage(data: data) ?? .init())
        } catch {
            print(error)
        }
    }

    func removeMosaic() {
        guard case .mosaic(let image) = viewData.loadState else { return }
        viewData.loadState = .loaded(image)
    }
}

/**
 要件
 モザイク・未読込・読み込みの状態に応じた表示
 別Viewとの読み込み状態の共有
 画像キャッシュ
 */
struct ThumbnailImageView: View {
    @StateObject private var viewModel: ThumbnailImageViewModel

    init(viewModel: ThumbnailImageViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        content
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.viewData.loadState {
        case .loaded(let uiImage):
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)

        case .mosaic(let uiImage):
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(alignment: .bottomTrailing) {
                    Text("モザイク")
                        .font(.system(size: 14).bold())
                }
                .onTapGesture {
                    viewModel.removeMosaic()
                }

        case .unloaded:
            Button("未読込") {
                Task { await viewModel.load() }
            }
        }
    }
}

struct ImageListScreen: View {
    @StateObject private var viewModel: ImageListViewModel
    @State private var isPresented = false

    init(viewModel: ImageListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                .init(.fixed(120), spacing: 5),
                .init(.fixed(120), spacing: 5),
                .init(.fixed(120), spacing: 5),
            ], spacing: 10, content: {
                Button("一覧表示") {
                    isPresented = true
                }

                ForEach(viewModel.viewData.imageURLs, id: \.absoluteString) { url in
                    ThumbnailImageView(viewModel: .init(url: url, dependency: .default(imageDisplayStorage: viewModel.imageDisplayStorage)))
                        .frame(width: 120, height: 120)
                        .border(Color.black)
                }
            })
        }
        .sheet(isPresented: $isPresented) {
            ImageListScreen(viewModel: ImageListViewModel(dependency: .default(imageDisplayStorage: viewModel.imageDisplayStorage)))
        }
    }
}

#Preview {
    ImageListScreen(viewModel: .init(dependency: .default(imageDisplayStorage: ImageDisplayStorage())))
}
