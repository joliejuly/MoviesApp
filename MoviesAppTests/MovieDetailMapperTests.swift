import XCTest

@testable import MVNetwork
@testable import MoviesApp

final class MovieDetailMapperTests: XCTestCase {
    func test_map_fromDTO_returnsExpectedMovieDetail() {
        
        let dto = MovieDetailDTO(
            id: 1,
            title: "Test Title",
            budget: 1000000,
            genres: [GenreDTO(id: 1, name: "Drama")],
            homepage: "https://example.com",
            imdbID: "tt1234567",
            originCountry: ["US"],
            originalLanguage: "en",
            originalTitle: "Original Test Title",
            overview: "A test movie.",
            popularity: 99.9,
            posterPath: "/poster.jpg",
            productionCompanies: [
                ProductionCompanyDTO(
                    id: 10,
                    logoPath: "/logo.png",
                    name: "Test Studio",
                    originCountry: "US"
                )
            ],
            productionCountries: [
                ProductionCountryDTO(name: "United States")
            ],
            releaseDate: Date(timeIntervalSince1970: 0),
            revenue: 2000000,
            runtime: 120,
            spokenLanguages: [
                SpokenLanguageDTO(
                    englishName: "English",
                    name: "English"
                )
            ],
            status: "Released",
            tagline: "This is a test."
        )
        
        let model = MovieDetailMapper.map(dto)
        
        XCTAssertEqual(model.id, dto.id)
        XCTAssertEqual(model.title, dto.title)
        XCTAssertEqual(model.genres.count, 1)
        XCTAssertEqual(model.genres.first?.name, "Drama")
        XCTAssertEqual(model.productionCompanies.first?.name, "Test Studio")
        XCTAssertEqual(model.spokenLanguages.first?.englishName, "English")
        XCTAssertEqual(model.releaseDate, dto.releaseDate)
    }
}

