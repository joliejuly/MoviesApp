protocol MovieService {
    func fetchLatest(page: Int) async throws -> Page<Movie>
    func fetchDetails(id: Int) async throws -> MovieDetail
    func fetchSuggestions(query: String) async throws -> [SuggestionMovie]
    func searchMovies(query: String) async throws -> [Movie]
}
