import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie?
    
    @StateObject private var viewModel = MovieDetailViewModel()
    @State private var detailImage: Image?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                image
                if let movie {
                    Text("Original title: \(movie.originalTitle)")
                        .font(.caption)
                }
                if let detail = viewModel.movieDetailInfo?.movieDetail {
                    Text("Genres: \(detail.genres.map(\.name).joined(separator: ", "))")
                        .font(.body)
                    Text("Budget: \(detail.budget)")
                        .font(.body)
                    Text(detail.overview)
                        .font(.body)
                } else {
                    ProgressView()
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .task(id: movie?.id) {
                try? await viewModel.loadDetails(for: movie)
                if let loadedImage = viewModel.movieDetailInfo?.movieImage {
                    detailImage = loadedImage
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(movie?.title ?? "Movie Detail")
    }
    
    private var image: some View {
        ThumbnailView(image: $detailImage, isLoading: $viewModel.isLoading, showPlaceholder: false)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .clipped()
    }
}
