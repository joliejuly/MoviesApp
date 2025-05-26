public protocol ImageLoader {
    func fetchImage(path: String, size: ImageSize) async throws -> Data
}

public enum ImageSize: CaseIterable {
    case small, medium, large
}
