import MVNetwork
import Dependencies

extension DependencyValues {
    var movieService: MovieService {
        get { self[MovieServiceKey.self] }
        set { self[MovieServiceKey.self] = newValue }
    }
}

private enum MovieServiceKey: DependencyKey {
    static let liveValue: MovieService = {
        let headerProvider = AuthHeaderProvider(tokenStore: DefaultTokenStore())
        let api = APIClient(headerProvider: headerProvider)
        let apiClient = TMDBApiClient(api: api)
        return MovieServiceImpl(apiClient: apiClient)
    }()
}
