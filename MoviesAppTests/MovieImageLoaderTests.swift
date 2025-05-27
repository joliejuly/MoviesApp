import XCTest
import SwiftUI
@testable import MoviesApp
import MVNetwork
import Dependencies

final class MovieImageLoaderImplTests: XCTestCase {
    var api: MockImageLoader!
    var loader: MovieImageLoaderImpl!
    
    override func setUp() {
        super.setUp()
        api = MockImageLoader()
        loader = withDependencies {
            $0.imageLoader = api
        } operation: {
            MovieImageLoaderImpl()
        }
    }
    
    override func tearDown() {
        api = nil
        loader = nil
        super.tearDown()
    }
    
    func testFetchThumbnailWithValidDataReturnsImage() async throws {
        let uiImage = UIImage(systemName: "person.fill")!
        let data = uiImage.pngData()!
        api.fetchResult = data
        
        let image = try await loader.fetchThumbnail(path: "/thumb.jpg")
        
        XCTAssertNotNil(image)
        XCTAssertEqual(api.fetchCalls.count, 1)
        XCTAssertEqual(api.fetchCalls.first!.path, "/thumb.jpg")
        XCTAssertEqual(api.fetchCalls.first!.size, .small)
    }
    
    func testFetchThumbnailWithInvalidDataReturnsNil() async throws {
        api.fetchResult = Data()
        
        let image = try await loader.fetchThumbnail(path: "/thumb.jpg")
        
        XCTAssertNil(image)
    }
    
    func testFetchDetailImageWithValidDataReturnsImage() async throws {
        let uiImage = UIImage(systemName: "star.fill")!
        let data = uiImage.pngData()!
        api.fetchResult = data
        
        let image = try await loader.fetchDetailImage(path: "/detail.jpg")
        
        XCTAssertNotNil(image)
        XCTAssertEqual(api.fetchCalls.count, 1)
        XCTAssertEqual(api.fetchCalls.first!.path, "/detail.jpg")
        XCTAssertEqual(api.fetchCalls.first!.size, .large)
    }
    
    func testClearCacheCallsAPI() async throws {
        await loader.clearCache()
        XCTAssertTrue(api.clearCalled)
    }
}


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
        return fetchResult!
    }
    
    func clearCache() async {
        clearCalled = true
    }
}
