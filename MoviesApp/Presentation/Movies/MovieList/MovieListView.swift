import SwiftUI

struct MovieListView: View {
    
    @StateObject private var viewModel = MovieListViewModel()
    
    @State private var path: [Movie] = []
    @State private var selectedMovie: Movie?
    @State private var searchText = ""
    @State private var showError = false
    @State private var isSearchPresented = true
    
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
            .overlay {
                if showError {
                  errorView
                }
            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .navigationTitle("New movies")
            .task {
                do {
                    try await viewModel.loadMoreIfNeeded()
                    isSearchPresented = true
                } catch {
                    showError = true
                    isSearchPresented = false
                }
            }
            .searchable(text: $searchText, isPresented: $isSearchPresented) {
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
            .onOneValueChange(of: searchText) { newValue in
                Task {
                    try? await viewModel.debounce()
                    await viewModel.updateSuggestions(for: newValue)
                }
            }
        }
    }
    
    private var errorView: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
            Text("Error loading movies.\nProbably api token is missing.")
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Button("Retry") {
                showError = false
                Task {
                    do {
                        try? await viewModel.debounce()
                        try await viewModel.loadMoreIfNeeded()
                    } catch {
                        showError = true
                        isSearchPresented = false
                    }
                }
            }
        }
    }
    
    private var filteredMovies: [Movie] {
        searchText.isEmpty ? viewModel.movies : viewModel.filteredMovies
    }
}
