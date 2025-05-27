protocol MovieService {
    func fetchLatest(page: Int) async throws -> Page<Movie>
    func fetchDetails(id: Int) async throws -> MovieDetail
    func searchMovies(query: String) async throws -> [Movie]
}
