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
