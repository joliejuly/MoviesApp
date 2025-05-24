import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel: MovieListViewModel = makeListVM() // TODO: dependency
    
    var body: some View {
        List(viewModel.movies) { movie in
            MovieCell(movie: movie)
                .task(id: movie.id) {
                    try? await viewModel.loadMoreIfNeeded(currentItem: movie)
                }
                .onTapGesture {
                    // TODO: show detail
                }
        }
        .navigationTitle("Recent movies")
        .task {
            try? await viewModel.loadMoreIfNeeded()
        }
    }
}
