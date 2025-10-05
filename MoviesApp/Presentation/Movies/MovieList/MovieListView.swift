import SwiftUI

/// Main list of movies with search
struct MovieListView: View {
    
    @ObservedObject var router: Router<MoviesRoute>
    
    @StateObject private var viewModel = MovieListViewModel()

    var body: some View {
        CommonNavigationView(router: router, destination: destination) {
            List(viewModel.moviesToShow) { movie in
                MovieCell(movie: movie)
                    .task(id: movie.id) {
                        try? await viewModel.loadMoreIfNeeded(currentItem: movie)
                    }
                    .listStyle(.plain)
                    .onTapGesture {
                        router.push(.detail(movie: movie))
                    }
            }
            .overlay {
                errorView
            }
            .navigationTitle("Top rated movies")
            .task {
                await viewModel.initialLoadMovies()
            }
            .task(id: viewModel.searchText) {
                await viewModel.updateSuggestions(for: viewModel.searchText)
            }
            .searchable(text: $viewModel.searchText, isPresented: $viewModel.isSearchPresented) {
                suggestionsView
            }
            .onSubmit(of: .search) {
                viewModel.loadSearchResults(query: viewModel.searchText)
            }
        }
    }
    
    private var suggestionsView: some View {
        ForEach(viewModel.suggestions.indices, id: \.self) { index in
            let suggestion = viewModel.suggestions[index]
            Button {
                viewModel.loadSearchResults(query: suggestion)
            } label: {
                Text(suggestion)
            }
            .searchCompletion(suggestion)
        }
    }
    
    @ViewBuilder
    private var errorView: some View {
        if viewModel.showError {
            VStack(spacing: 24) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                Text("Error loading movies.\nProbably api token is missing.")
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Button("Retry") {
                    viewModel.retryLoadingMovies()
                }
            }
        }
    }
    
    @ViewBuilder
    private func destination(_ route: MoviesRoute) -> some View {
        if case .detail(let movie) = route {
            MovieDetailView(movie: movie)
        } else {
            EmptyView()
        }
    }
}
