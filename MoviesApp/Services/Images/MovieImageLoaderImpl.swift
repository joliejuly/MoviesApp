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
        return await image(from: data)
    }
    
    func fetchDetailImage(path: String) async throws -> Image? {
        let data = try await api.fetchImage(path: path, size: .large)
        return await image(from: data)
    }
    
    func clearCache() async {
        await api.clearCache()
    }
    
    private func image(from data: Data) async -> Image? {
        let task = Task<Image?, Never> {
            guard
                let uiImage = UIImage(data: data),
                let im = await uiImage.byPreparingForDisplay()
            else { return nil }
            return Image(uiImage: im)
        }
        return await task.value
    }
}
