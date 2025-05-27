import XCTest
@testable import MVNetwork

final class TMDBApiImageLoaderTests: XCTestCase {
    var apiClient: MockAPIClient!
    var loader: TMDBApiImageLoader!
    let baseURL = URL(string: "https://example.com")!
    
    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        loader = TMDBApiImageLoader(api: apiClient, baseURL: baseURL)
    }
    
    override func tearDown() {
        apiClient = nil
        loader = nil
        super.tearDown()
    }
    
    func testFetchImage_FirstTime_CallsConfigAndFetchesData() async throws {
        let posterSizes = ["w92", "w154", "w342"]
        let secureBaseUrl = "https://images.example.com/"
        let configDTO = ConfigurationDTO(
            images: ImageConfigurationDTO(
                secureBaseUrl: secureBaseUrl,
                posterSizes: posterSizes
            )
        )
        apiClient.sendResult = .success(configDTO)
        
        let expectedData = "fakeImageData".data(using: .utf8)!
        apiClient.fetchDataResult = .success(expectedData)
        
        let data = try await loader.fetchImage(path: "/poster.jpg", size: .small)
    
        XCTAssertEqual(data, expectedData)
        XCTAssertEqual(apiClient.sendCount, 1, "should fetch configuration once")
        XCTAssertEqual(apiClient.fetchDataCount, 1, "should fetch image data once")
    }
    
    func testFetchImage_WhenConfigFails_ThrowsError() async {
        
        apiClient.sendResult = .failure(TestError.configFailed)
        
        do {
            _ = try await loader.fetchImage(path: "/poster.jpg", size: .small)
            XCTFail("Expected to throw TestError.configFailed")
        } catch let error as TestError {
            XCTAssertEqual(error, .configFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchImage_WhenFetchDataFails_ThrowsError() async {
        let posterSizes = ["thumb"]
        apiClient.sendResult = .success(
            ConfigurationDTO(
                images: ImageConfigurationDTO(
                    secureBaseUrl: "https://imgs/",
                    posterSizes: posterSizes
                )
            )
        )
        apiClient.fetchDataResult = .failure(TestError.fetchFailed)
        
        do {
            _ = try await loader.fetchImage(path: "/poster.jpg", size: .small)
            XCTFail("Expected to throw TestError.fetchFailed")
        } catch let error as TestError {
            XCTAssertEqual(error, .fetchFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
