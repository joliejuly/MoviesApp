import MVNetwork

final class MockMovieAPIClient: MovieAPIClient {
    
    var lastPageRequested: Int?
    var lastDetailID: Int?
    var latestStub: PaginatedResponseDTO<MovieDTO>!
    var detailStub: MovieDetailDTO!
    var shouldThrowLatest = false
    var shouldThrowDetail = false
    
    func fetchLatestMovies(page: Int) async throws -> PaginatedResponseDTO<MovieDTO> {
        lastPageRequested = page
        if shouldThrowLatest { throw URLError(.badServerResponse) }
        return latestStub
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetailDTO {
        lastDetailID = id
        if shouldThrowDetail { throw URLError(.badServerResponse) }
        return detailStub
    }
    
    func searchMovies(query: String) async throws -> [MVNetwork.MovieDTO] {
      return []
    }
    
    func fetchSuggestions(query: String) async throws -> [SuggestionMovieDTO] {
        return []
    }
    
}
