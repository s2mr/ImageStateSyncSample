import SwiftUI

enum DummyImages {
    static let imageURLs: [URL] = {
        (0..<50).map { number in
            URL(string: "https://placehold.jp/150x150.png?text=\(number)")!
        }
    }()
}


extension ImageDisplayState {
    func isEqual(to other: ImageLoadState) -> Bool {
        switch (self, other) {
        case (.loaded, .loaded),
            (.mosaic, .mosaic),
            (.unloaded, .unloaded):
            return true

        case (.loaded, _),
            (.mosaic, _),
            (.unloaded, _):
            return false
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
