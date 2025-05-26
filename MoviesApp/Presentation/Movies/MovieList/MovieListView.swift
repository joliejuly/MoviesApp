import SwiftUI

struct MovieListView: View {
    
    @StateObject private var viewModel = MovieListViewModel()
    
    @State private var path: [Movie] = []
    @State private var selectedMovie: Movie?
    
    var body: some View {
        NavigationStack(path: $path) {
            List(viewModel.movies) { movie in
                NavigationLink(value: movie) {
                    MovieCell(movie: movie)
                        .task(id: movie.id) {
                            try? await viewModel.loadMoreIfNeeded(currentItem: movie)
                        }
                }
            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .navigationTitle("New movies")
            .task {
                try? await viewModel.loadMoreIfNeeded()
            }
        }
    }
}
