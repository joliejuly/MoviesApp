import MVNetwork
import Dependencies

extension DependencyValues {
    
    var headerProvider: HeaderProvider {
        get { self[HeaderProviderKey.self] }
        set { self[HeaderProviderKey.self] = newValue }
    }
    
    var apiClient: APIClientProtocol {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
    
    var movieAPIClient: MovieAPIClient {
        get { self[TMDBApiClientKey.self] }
        set { self[TMDBApiClientKey.self] = newValue }
    }
    
    var movieService: MovieService {
        get { self[MovieServiceKey.self] }
        set { self[MovieServiceKey.self] = newValue }
    }
    
    var movieImageLoader: MovieImageLoader {
        get { self[MovieImageLoaderKey.self] }
        set { self[MovieImageLoaderKey.self] = newValue }
    }
}

// MARK: – Keys

private enum HeaderProviderKey: DependencyKey {
    static let liveValue: HeaderProvider = AuthHeaderProvider(
        tokenStore: DefaultTokenStore()
    )
}

private enum APIClientKey: DependencyKey {
    static let liveValue: APIClientProtocol = APIClient(
        headerProvider: HeaderProviderKey.liveValue
    )
}

private enum TMDBApiClientKey: DependencyKey {
    static let liveValue: MovieAPIClient = TMDBApiClient(
        api: APIClientKey.liveValue
    )
}

private enum MovieServiceKey: DependencyKey {
    static let liveValue: MovieService = MovieServiceImpl(
        apiClient: TMDBApiClientKey.liveValue
    )
}

private enum ImageLoaderKey: DependencyKey {
    static let liveValue: ImageLoader = TMDBApiImageLoader(
        api: APIClientKey.liveValue
    )
}

private enum MovieImageLoaderKey: DependencyKey {
    static let liveValue: MovieImageLoader = MovieImageLoaderImpl(
        apiClient: ImageLoaderKey.liveValue
    )
}
