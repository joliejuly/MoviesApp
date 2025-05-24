import SwiftUI
import MVNetwork

@main
struct MoviesAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MovieListView()
            }
            
        }
    }
}

@MainActor func makeListVM() -> MovieListViewModel {
    let headerProvider = AuthHeaderProvider(tokenStore: DefaultTokenStore())
    let api = APIClient(headerProvider: headerProvider)
    let apiClient = TMDBApiClient(api: api)
    let repo = MovieService(apiClient: apiClient)
    let viewModel = MovieListViewModel(repository: repo)
    return viewModel
}
