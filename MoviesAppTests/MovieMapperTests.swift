import XCTest
@testable import MoviesApp
@testable import MVNetwork

final class MovieMapperTests: XCTestCase {
    func testMap_CopiesAllFields() {
        let dto = MovieDTO(
            id: 42,
            title: "the quick brown fox",
            originalTitle: "Original Title",
            posterPath: "/poster.jpg",
            releaseDate: Date(),
            voteAverage: 8.7
        )
        let movie = MovieMapper.map(dto)
        XCTAssertEqual(movie.id, 42)
        XCTAssertEqual(movie.title, "Original Title")
        let expectedOriginalTitle = dto.title.capitalized(with: Locale.autoupdatingCurrent)
        XCTAssertEqual(movie.originalTitle, expectedOriginalTitle)
        XCTAssertEqual(movie.posterPath, "/poster.jpg")
    }
    
    func testMap_CapitalizesTitleProperly() {
        let dto = MovieDTO(
            id: 0,
            title: "test",
            originalTitle: "",
            posterPath: "",
            releaseDate: Date(),
            voteAverage: 8.7
        )
        let movie = MovieMapper.map(dto)
        XCTAssertEqual(movie.originalTitle, "Test")
    }
}
