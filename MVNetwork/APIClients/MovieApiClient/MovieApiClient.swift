import Foundation

public protocol MovieAPIClient {
    func fetchLatestMovies(page: Int) async throws -> PaginatedResponseDTO<MovieDTO>
    func fetchMovieDetail(id: Int) async throws -> MovieDTO
}
