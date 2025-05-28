import struct SwiftUI.Image

final class MockMovieImageLoader: MovieImageLoader {
   
    func fetchThumbnail(path: String) async throws -> Image? {
        return nil
    }
    
    func fetchDetailImage(path: String) async throws -> Image? {
        return nil
    }
    
    func clearCache() async {
        
    }
}
