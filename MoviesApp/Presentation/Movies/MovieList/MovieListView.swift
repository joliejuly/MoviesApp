import SwiftUI

struct MovieListView: View {
    
    @StateObject private var viewModel = MovieListViewModel()
    
    @State private var path: [Movie] = []
    @State private var selectedMovie: Movie?
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            List(filteredMovies) { movie in
                NavigationLink(value: movie) {
                    MovieCell(movie: movie)
                        .task(id: movie.id) {
                            try? await viewModel.loadMoreIfNeeded(currentItem: movie)
                        }
                }
                .listStyle(.plain)
            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .navigationTitle("New movies")
            .task {
                try? await viewModel.loadMoreIfNeeded()
            }
            .searchable(text: $searchText) {
                ForEach(viewModel.suggestions.indices, id: \.self) { index in
                    let suggestion = viewModel.suggestions[index]
                    Button {
                        Task {
                            try await viewModel.loadSearchResults(query: suggestion)
                        }
                    } label: {
                        Text(suggestion)
                    }
                    .searchCompletion(suggestion)
                }
            }
            .onSubmit(of: .search) {
                Task {
                    try await viewModel.loadSearchResults(query: searchText)
                }
            }
            .onChange(of: searchText) { _, newValue in
                Task {
                    await viewModel.updateSuggestions(for: newValue)
                }
            }
        }
    }
    
    private var filteredMovies: [Movie] {
        searchText.isEmpty ? viewModel.movies : viewModel.filteredMovies
    }
}
