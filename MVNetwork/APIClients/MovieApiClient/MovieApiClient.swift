import Foundation

public protocol MovieAPIClient {
    func fetchLatestMovies(page: Int) async throws -> PaginatedResponseDTO<MovieDTO>
    func fetchMovieDetail(id: Int) async throws -> MovieDetailDTO
    func searchMovies(query: String) async throws -> [MovieDTO]
}
