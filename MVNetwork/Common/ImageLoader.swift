public protocol ImageLoader {
    func fetchImage(path: String, size: ImageSize) async throws -> Data
    func clearCache() async
}

public enum ImageSize: CaseIterable {
    case small, medium, large
}
