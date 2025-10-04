public struct TMDBApiClient: MovieAPIClient {
    
    private let baseURL: URL
    private let api: APIClientProtocol
    
    private var imageConfig: ImageConfigurationDTO?
    
    private var language: String {
        Locale.autoupdatingCurrent.identifier
    }
    
    private var shortLanguageCode: String {
        String(language.split(separator: "-").first ?? "en")
    }

    public init(api: APIClientProtocol, baseURL: URL = Constants.baseURL) {
        self.api = api
        self.baseURL = baseURL
    }
    
    public func fetchLatestMovies(page: Int) async throws -> PaginatedResponseDTO<MovieDTO> {
        
        let date = yyyyMMddDateFormatter.string(from: Date())
        
        let endpoint = Endpoint(
            path: "movie/top_rated",
            queryItems: [
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "sort_by", value: "release_date.desc"),
                URLQueryItem(name: "release_date.lte", value: date),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "append_to_response", value: "images"),
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "include_image_language", value: "\(shortLanguageCode),null")
            ]
        )
        return try await api.send(endpoint, type: PaginatedResponseDTO<MovieDTO>.self, baseURL: baseURL)
    }
    
    public func fetchMovieDetail(id: Int) async throws -> MovieDetailDTO {
        let endpoint = Endpoint(
            path: "movie/\(id)",
            queryItems: [
                URLQueryItem(name: "language", value: language)
            ]
        )
        return try await api.send(endpoint, type: MovieDetailDTO.self, baseURL: baseURL)
    }
    
    public func fetchSuggestions(query: String) async throws -> [SuggestionMovieDTO] {
        let result = try await api.send(searchEndpoint(query), type: PaginatedResponseDTO<SuggestionMovieDTO>.self, baseURL: baseURL)
        return result.results
    }
    
    public func searchMovies(query: String) async throws -> [MovieDTO] {
        let result = try await api.send(searchEndpoint(query), type: PaginatedResponseDTO<MovieDTO>.self, baseURL: baseURL)
        
        return result.results
    }
    
    private func searchEndpoint(_ query: String) -> Endpoint {
        Endpoint(
            path: "search/movie",
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "sort_by", value: "release_date.desc"),
                URLQueryItem(name: "append_to_response", value: "images"),
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "include_image_language", value: "\(shortLanguageCode),null")
            ]
        )
    }
}
