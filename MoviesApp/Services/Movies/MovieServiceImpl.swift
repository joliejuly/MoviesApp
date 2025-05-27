import MVNetwork

final class MovieServiceImpl: MovieService {
    private let api: MovieAPIClient
    
    init(apiClient: MovieAPIClient) {
        self.api = apiClient
    }
    
    func fetchLatest(page: Int) async throws -> Page<Movie> {
        let dtoPage = try await api.fetchLatestMovies(page: page)
        let movies = dtoPage.results.map { MovieMapper.map($0) }
        return Page(
            index: dtoPage.page,
            items: movies,
            totalPages: dtoPage.totalPages
        )
    }
    
    func fetchDetails(id: Int) async throws -> MovieDetail {
        let dto = try await api.fetchMovieDetail(id: id)
        let movieDetail = MovieDetailMapper.map(dto)
        return movieDetail
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        let dto = try await api.searchMovies(query: query)
        let movies = dto.map { MovieMapper.map($0) }
        return movies
    }
}
