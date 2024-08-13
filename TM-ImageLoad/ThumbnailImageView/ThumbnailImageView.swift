import SwiftUI
import Foundation

@MainActor
struct ThumbnailImageView: View {
    @ObservedObject var viewModel: ThumbnailImageViewModel

    init(viewModel: ThumbnailImageViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        content
            .frame(minWidth: 120, minHeight: 120)
            .border(.black)
            .overlay(alignment: .bottomLeading) {
                Text("\(viewModel.viewData.index)")
            }
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
