protocol MovieService {
    func fetchNowPlaying(page: Int) async throws -> Page<Movie>
}
