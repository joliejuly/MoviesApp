protocol MovieRepository {
    func fetchNowPlaying(page: Int) async throws -> Page<Movie>
}
