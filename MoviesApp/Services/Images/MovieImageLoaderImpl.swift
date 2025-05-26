import MVNetwork
import UIKit
import struct SwiftUI.Image

final class MovieImageLoaderImpl: MovieImageLoader {
    
    private let api: ImageLoader
    
    init(apiClient: ImageLoader) {
        self.api = apiClient
    }
    
    func fetchThumbnail(path: String) async throws -> Image? {
        let data = try await api.fetchImage(path: path, size: .small)
        return image(from: data)
    }
    
    func fetchDetailImage(path: String) async throws -> Image? {
        let data = try await api.fetchImage(path: path, size: .large)
        return image(from: data)
    }
    
    func clearCache() async {
        await api.clearCache()
    }
    
    private func image(from data: Data) -> Image? {
        guard let uiImage = UIImage(data: data) else { return nil }
        let image = Image(uiImage: uiImage)
        return image
    }
}
