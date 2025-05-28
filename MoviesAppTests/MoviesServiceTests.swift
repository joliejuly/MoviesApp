import XCTest
@testable import MoviesApp
@testable import MVNetwork
import Dependencies

final class MovieServiceImplTests: XCTestCase {
    var api: MockMovieAPIClient!
    var service = MovieServiceImpl()
    
    override func invokeTest() {
        let api = MockMovieAPIClient()
        self.api = api
        withDependencies {
            $0.movieAPIClient = api
        } operation: {
            super.invokeTest()
        }
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
