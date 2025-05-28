import XCTest
import SwiftUI
@testable import MoviesApp
import MVNetwork
import Dependencies

final class MovieImageLoaderImplTests: XCTestCase {
    var loader: MovieImageLoaderImpl = MovieImageLoaderImpl()
    var api: MockImageLoader!
    
    override func invokeTest() {
        let api = MockImageLoader()
        self.api = api
        withDependencies {
            $0.imageLoader = api
        } operation: {
            super.invokeTest()
        }
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
