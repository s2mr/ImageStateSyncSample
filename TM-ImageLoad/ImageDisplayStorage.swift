import Combine
import Foundation

final class ImageDisplayStorage {
    private var displayStates: [URL: ImageDisplayState] = [:]

    let didChange = PassthroughSubject<(URL, ImageDisplayState), Never>()

    init() {
    }

    func set(for url: URL, state: ImageDisplayState) {
        displayStates[url] = state

        didChange.send((url, state))
    }

    func getState(for url: URL) -> ImageDisplayState {
        displayStates[url] ?? .unloaded
    }
}
