import XCTest
@testable import MVNetwork

private enum TestError: Error, Equatable {
    case noStub, fetchFailed, configFailed
}

final class MockImageLoader: APIClientProtocol {

    var configResult: Result<ConfigurationDTO, Error> = .failure(TestError.noStub)
    var fetchDataResult: Result<Data, Error> = .failure(TestError.noStub)
    
    var sendCount = 0
    var fetchDataCount = 0
    
    func send<T>(
        _ endpoint: Endpoint,
        type: T.Type,
        baseURL: URL
    ) async throws -> T where T : Decodable {
        sendCount += 1
        switch configResult {
            case .success(let configDTO) where T.self == ConfigurationDTO.self:
                return configDTO as! T
            case .failure(let err):
                throw err
            default:
                fatalError("Unexpected type \(T.self) for configResult stub")
        }
    }
    
    func fetchData(
        _ endpoint: Endpoint,
        baseURL: URL
    ) async throws -> Data {
        fetchDataCount += 1
        switch fetchDataResult {
            case .success(let data):
                return data
            case .failure(let err):
                throw err
        }
    }
}

final class TMDBApiImageLoaderTests: XCTestCase {
    var apiClient: MockImageLoader!
    var loader: TMDBApiImageLoader!
    let baseURL = URL(string: "https://example.com")!
    
    override func setUp() {
        super.setUp()
        apiClient = MockImageLoader()
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
        apiClient.configResult = .success(configDTO)
        
        let expectedData = "fakeImageData".data(using: .utf8)!
        apiClient.fetchDataResult = .success(expectedData)
        
        let data = try await loader.fetchImage(path: "/poster.jpg", size: .small)
    
        XCTAssertEqual(data, expectedData)
        XCTAssertEqual(apiClient.sendCount, 1, "should fetch configuration once")
        XCTAssertEqual(apiClient.fetchDataCount, 1, "should fetch image data once")
    }
    
    func testFetchImage_ReturnsCachedDataOnSecondCall() async throws {
        // Arrange (same as first test)
        let posterSizes = ["thumb", "mid", "large"]
        let secureBaseUrl = "https://images.example.com/"
        apiClient.configResult = .success(
            ConfigurationDTO(
                images: ImageConfigurationDTO(
                    secureBaseUrl: secureBaseUrl,
                    posterSizes: posterSizes
                )
            )
        )
        let expectedData = "cachedImage".data(using: .utf8)!
        apiClient.fetchDataResult = .success(expectedData)
        
        // First fetch
        let first = try await loader.fetchImage(path: "/poster.jpg", size: .small)
        XCTAssertEqual(first, expectedData)
        XCTAssertEqual(apiClient.sendCount, 1)
        XCTAssertEqual(apiClient.fetchDataCount, 1)
        
        // Reset fetch‐data count to ensure it doesn't go up
        apiClient.fetchDataCount = 0
        
        let second = try await loader.fetchImage(path: "/poster.jpg", size: .small)
        
        XCTAssertEqual(second, expectedData)
        XCTAssertEqual(apiClient.sendCount, 1, "should not fetch config again")
        XCTAssertEqual(apiClient.fetchDataCount, 0, "should return cached data without calling fetchData")
    }
    
    func testFetchImage_WhenConfigFails_ThrowsError() async {
        
        apiClient.configResult = .failure(TestError.configFailed)
        
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
        apiClient.configResult = .success(
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
    
    func testClearCache_EmptiesBothCaches() async throws {
        let posterSizes = ["thumb"]
        let secureBaseUrl = "https://imgs/"
        apiClient.configResult = .success(
            ConfigurationDTO(
                images: ImageConfigurationDTO(
                    secureBaseUrl: secureBaseUrl,
                    posterSizes: posterSizes
                )
            )
        )
        let data1 = "first".data(using: .utf8)!
        apiClient.fetchDataResult = .success(data1)
        
        _ = try await loader.fetchImage(path: "/poster.jpg", size: .small)
        XCTAssertEqual(apiClient.fetchDataCount, 1)
        
        await loader.clearCache()
        
        let data2 = "second".data(using: .utf8)!
        apiClient.fetchDataResult = .success(data2)
        apiClient.fetchDataCount = 0
        
        let fetched = try await loader.fetchImage(path: "/poster.jpg", size: .small)
        
        XCTAssertEqual(fetched, data2)
        XCTAssertEqual(apiClient.fetchDataCount, 1)
    }
}
