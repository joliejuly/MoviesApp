import MVNetwork

final class MovieService: MovieRepository {
    private let api: MovieAPIClient
    
    init(apiClient: MovieAPIClient) {
        self.api = apiClient
    }
    
    func fetchNowPlaying(page: Int) async throws -> Page<Movie> {
        let dtoPage = try await api.fetchLatestMovies(page: page)
        let movies = dtoPage.results.map { Movie(dto: $0) }
        return Page(
            index: dtoPage.page,
            items: movies,
            totalPages: dtoPage.totalPages
        )
    }
}
