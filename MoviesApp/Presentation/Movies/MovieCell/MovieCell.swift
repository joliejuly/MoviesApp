import SwiftUI

/// A cell that is displayed in MovieListView with a thumbnail image and basic info
struct MovieCell: View {
    let movie: Movie
    
    @StateObject private var viewModel = MovieCellViewModel()
    
    var body: some View {
        HStack(alignment: .top) {
            thumbnail
                .padding(.trailing, 16)
            VStack(alignment: .leading, spacing: 12) {
                Text(movie.originalTitle)
                    .font(.headline)
                if let originalTitle = viewModel.originalTitle(for: movie) {
                    Text(originalTitle)
                        .font(.body)
                }
                if let releaseDate = viewModel.releaseYear(for: movie) {
                    Text(releaseDate)
                        .font(.caption)
                }
                if let rating = viewModel.rating(for: movie) {
                    Text(rating)
                        .font(.caption)
                }
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .task(id: movie.id) {
           try? await viewModel.loadImage(for: movie)
        }
    }
    
    private var thumbnail: some View {
        ThumbnailView(image: $viewModel.image, isLoading: $viewModel.isLoading, showPlaceholder: true)
            .frame(width: 82)
    }
}
