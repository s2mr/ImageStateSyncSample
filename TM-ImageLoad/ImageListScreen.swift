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
    case unloaded
}

struct ThumbnailImageViewData {
    var url: URL
    var loadState: ImageLoadState
}

final class ThumbnailImageViewModel: ObservableObject {
    @Published var viewData: ThumbnailImageViewData

    init(url: URL) {
        _viewData = .init(
            initialValue: ThumbnailImageViewData(url: url, loadState: .unloaded)
        )
    }

    func load() async {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: viewData.url))
            viewData.loadState = .loaded(UIImage(data: data) ?? .init())
        } catch {
            print(error)
        }
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

    init(url: URL) {
        self._viewModel = .init(wrappedValue: ThumbnailImageViewModel(url: url))
    }

    var body: some View {
        switch viewModel.viewData.loadState {
        case .loaded(let uIImage):
            Image(uiImage: uIImage)
                .resizable()
                .aspectRatio(contentMode: .fit)

        case .unloaded:
            Button("未読込") {
                Task { await viewModel.load() }
            }
        }
    }
}

struct ImageListScreen: View {
    @StateObject private var viewModel = ImageListViewModel()
    @State private var isPresented = false

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
                    ThumbnailImageView(url: url)
                        .frame(width: 120, height: 120)
                        .border(Color.black)
                }
            })
        }
        .sheet(isPresented: $isPresented) {
            ImageListScreen()
        }
    }
}

#Preview {
    ImageListScreen()
}
