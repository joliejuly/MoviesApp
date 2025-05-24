import MVNetwork

// TODO: move to Dependencies
@MainActor func makeListVM() -> MovieListViewModel {
    let headerProvider = AuthHeaderProvider(tokenStore: DefaultTokenStore())
    let api = APIClient(headerProvider: headerProvider)
    let apiClient = TMDBApiClient(api: api)
    let movieService = MovieServiceImpl(apiClient: apiClient)
    let viewModel = MovieListViewModel(movieService: movieService)
    return viewModel
}

// TODO: move to Dependencies
@MainActor func makeDetailVM() -> MovieDetailViewModel {
    let headerProvider = AuthHeaderProvider(tokenStore: DefaultTokenStore())
    let api = APIClient(headerProvider: headerProvider)
    let apiClient = TMDBApiClient(api: api)
    let movieService = MovieServiceImpl(apiClient: apiClient)
    let viewModel = MovieDetailViewModel(movieService: movieService)
    return viewModel
}
