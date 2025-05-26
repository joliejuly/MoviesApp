import struct SwiftUI.Image

protocol MovieImageLoader {
    func fetchThumbnail(path: String) async throws -> Image?
    func fetchDetailImage(path: String) async throws -> Image?
}
