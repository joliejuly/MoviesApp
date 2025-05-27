import XCTest
@testable import MoviesApp
@testable import MVNetwork
import Dependencies

final class MovieServiceImplTests: XCTestCase {
    var api: StubAPI!
    var service: MovieServiceImpl!
    
    override func setUp() {
        super.setUp()
        api = StubAPI()
        
        service = withDependencies {
            $0.movieAPIClient = api
        } operation: {
            MovieServiceImpl()
        }
    }
    
    override func tearDown() {
        api = nil
        service = nil
        super.tearDown()
    }
    
    func testFetchLatest_ReturnsMappedPage() async throws {
        let dtos = [
            MovieDTO(id: 10, title: "t", originalTitle: "OT", posterPath: "/p")
        ]
        api.latestStub = PaginatedResponseDTO(
            page: 2,
            results: dtos,
            totalPages: 5,
            totalResults: 100
        )
    
        let page = try await service.fetchLatest(page: 99)

        XCTAssertEqual(api.lastPageRequested, 99)
        XCTAssertEqual(page.index, 2)
        XCTAssertEqual(page.totalPages, 5)
        XCTAssertEqual(page.items.count, 1)
        XCTAssertEqual(page.items.first?.id, 10)
    }
    
    func testFetchLatest_PropagatesError() async {
        api.shouldThrowLatest = true
        do {
            _ = try await service.fetchLatest(page: 1)
            XCTFail("Expected error")
        } catch {
            // success
        }
    }
}

final class StubAPI: MovieAPIClient {
    var lastPageRequested: Int?
    var lastDetailID: Int?
    var latestStub: PaginatedResponseDTO<MovieDTO>!
    var detailStub: MovieDetailDTO!
    var shouldThrowLatest = false
    var shouldThrowDetail = false
    
    func fetchLatestMovies(page: Int) async throws -> PaginatedResponseDTO<MovieDTO> {
        lastPageRequested = page
        if shouldThrowLatest { throw URLError(.badServerResponse) }
        return latestStub
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetailDTO {
        lastDetailID = id
        if shouldThrowDetail { throw URLError(.badServerResponse) }
        return detailStub
    }
    
    func searchMovies(query: String) async throws -> [MVNetwork.MovieDTO] {
      return []
    }
    
}
