import Foundation
import UIKit

final class ImageLoader {
    func loadImage(url: URL) async -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            return UIImage(data: data) ?? .init()
        } catch {
            print(error)
            return .init()
        }
    }
}
