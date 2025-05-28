import MVNetwork
import struct SwiftUI.Image

final class MockImageLoader: ImageLoader {
    
    var fetchCalls: [(path: String, size: ImageSize)] = []
    var fetchResult: Data?
    var fetchError: Error?
    var clearCalled = false
    
    func fetchImage(path: String, size: ImageSize) async throws -> Data {
        fetchCalls.append((path: path, size: size))
        if let err = fetchError {
            throw err
        }
        return fetchResult ?? Data()
    }
    
    func clearCache() async {
        clearCalled = true
    }
}
