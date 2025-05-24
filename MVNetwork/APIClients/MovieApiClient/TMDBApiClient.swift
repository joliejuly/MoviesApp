public struct TMDBApiClient: MovieAPIClient {
    
    private let baseURL: URL
    private let api: APIClient
    
    public init(api: APIClient, baseURL: URL = Constants.baseURL) {
        self.api = api
        self.baseURL = baseURL
    }
    
    public func fetchLatestMovies(page: Int) async throws -> PaginatedResponseDTO<MovieDTO> {
        
        let date = yyyyMMddDateFormatter.string(from: Date())
        let language = Locale.autoupdatingCurrent.identifier
        let shortLanguageCode = language.split(separator: "-").first ?? "en"
        
        let endpoint = Endpoint(
            path: "discover/movie",
            queryItems: [
                URLQueryItem(name: "sort_by", value: "release_date.desc"),
                URLQueryItem(name: "release_date.lte", value: date),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "append_to_response", value: "images"),
//                URLQueryItem(name: "language", value: language),
//                URLQueryItem(name: "include_image_language", value: "\(shortLanguageCode),null")
            ]
        )
        return try await api.send(endpoint, type: PaginatedResponseDTO<MovieDTO>.self, baseURL: baseURL)
    }
    
    public func fetchMovieDetail(id: Int) async throws -> MovieDTO {
        // TODO:
        return MovieDTO(id: 1)
    }
}


