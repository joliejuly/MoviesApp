import XCTest
@testable import MVNetwork

final class TMDBApiClientTests: XCTestCase {
    var apiClient: MockAPIClient!
    var client: TMDBApiClient!
    let baseURL = URL(string: "http://test")!
    
    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        client = TMDBApiClient(api: apiClient, baseURL: baseURL)
    }
    
    override func tearDown() {
        apiClient = nil
        client = nil
        super.tearDown()
    }
    
    func testFetchLatestMovies_CallsSendWithCorrectEndpoint() async throws {
        let stub = PaginatedResponseDTO<MovieDTO>(
            page: 1,
            results: [],
            totalPages: 1,
            totalResults: 0
        )
        apiClient.sendResult = .success(stub)
        
        let page = 3
        _ = try await client.fetchLatestMovies(page: page)
        
        XCTAssertEqual(apiClient.sendCount, 1)
    }
    
    func testFetchLatestMovies_PropagatesError() async {
        apiClient.sendResult = .failure(TestError.fetchFailed)
        
        do {
            let res = try await client.fetchLatestMovies(page: 1)
            XCTFail("Expected error, got \(res)")
        } catch {
            XCTAssertEqual(error as? TestError, .fetchFailed)
        }
    }
    
    func testFetchMovieDetail_PropagatesError() async {
        apiClient.sendResult = .failure(TestError.fetchFailed)
        
        do {
            let res = try await client.fetchMovieDetail(id: 7)
            XCTFail("Expected error, got \(res)")
        } catch {
            XCTAssertEqual(error as? TestError, .fetchFailed)
        }
    }
}
