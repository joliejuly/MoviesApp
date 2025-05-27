import XCTest

@testable import MVNetwork
@testable import MoviesApp

final class MovieDetailMapperTests: XCTestCase {
    
    func test_map_fromDTO_returnsExpectedMovieDetail() {
        let genre = GenreDTO(id: 5, name: "Action")
        let dto = MovieDetailDTO(
            id: 42,
            title: "Test Title",
            budget: 12345,
            genres: [genre],
            originalTitle: "Original Title",
            overview: "Some overview",
            posterPath: "/path.jpg"
        )
        
        let model = MovieDetailMapper.map(dto)
        
        XCTAssertEqual(model.id, dto.id)
        XCTAssertEqual(model.title, dto.title)
        XCTAssertEqual(model.budget, dto.budget)
        XCTAssertEqual(model.originalTitle, dto.originalTitle)
        XCTAssertEqual(model.overview, dto.overview)
    }
}

