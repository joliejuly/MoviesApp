import struct SwiftUI.Image

/// Loads movie posters
protocol MovieImageLoader {
    func fetchThumbnail(path: String) async throws -> Image?
    func fetchDetailImage(path: String) async throws -> Image?
    func clearCache() async
}
