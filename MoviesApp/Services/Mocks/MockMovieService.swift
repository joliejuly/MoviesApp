import Foundation
final class MockMovieService: MovieService {
    
    func fetchLatest(page: Int) async throws -> Page<Movie> {
        return Page(
            index: 1,
            items: [
                Movie(id: 1, title: "Mock Movie 1", originalTitle: "", posterPath: "/mock1.jpg", releaseDate: Date(), rating: 8.7),
                Movie(id: 2, title: "Mock Movie 2", originalTitle: "", posterPath: "/mock2.jpg", releaseDate: Date(), rating: 8.8)
            ],
            totalPages: 1
        )
    }
    
    func fetchDetails(id: Int) async throws -> MovieDetail {
        return MovieDetail(
            id: id,
            title: "Mock Movie Detail \(id)",
            budget: 100000,
            genres: nil,
            originalTitle: "Mock Original Title",
            overview: "This is a mock overview of the movie."
        )
    }

    func fetchSuggestions(query: String) async throws -> [SuggestionMovie] {
        return [
            SuggestionMovie(id: 1, title: "Mock Movie 1"),
            SuggestionMovie(id: 2, title: "Mock Movie 2")
        ]
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        return [
            Movie(id: 1, title: "Mock Movie 1", originalTitle: "", posterPath: "/mock1.jpg", releaseDate: Date(), rating: 8.8),
            Movie(id: 2, title: "Mock Movie 2", originalTitle: "", posterPath: "/mock2.jpg", releaseDate: Date(), rating: 8.8)
        ]
    }
}

struct FailingMovieService: MovieService {
    struct Boom: Error {}
    func fetchLatest(page: Int) async throws -> Page<Movie> { throw Boom() }
    func fetchDetails(id: Int) async throws -> MovieDetail { throw Boom() }
    func fetchSuggestions(query: String) async throws -> [SuggestionMovie] { throw Boom() }
    func searchMovies(query: String) async throws -> [Movie] { throw Boom() }
}
