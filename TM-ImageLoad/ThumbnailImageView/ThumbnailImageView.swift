import SwiftUI
import Foundation

struct ThumbnailImageView: View {
    @StateObject private var viewModel: ThumbnailImageViewModel

    init(viewModel: ThumbnailImageViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        content
            .task {
                await viewModel.onAppear()
            }
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
