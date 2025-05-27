import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie?
    
    @StateObject private var viewModel = MovieDetailViewModel()
    @State private var detailImage: Image?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                image
                details
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                Spacer()
            }
            .task(id: movie?.id) {
                try? await viewModel.loadDetails(for: movie)
                if let loadedImage = viewModel.movieDetailInfo?.movieImage {
                    detailImage = loadedImage
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .padding(.horizontal, 24)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(movie?.title ?? "Movie Detail")
    }
    
    @ViewBuilder
    private var details: some View {
        if let movie {
            Text("Original title: \(movie.originalTitle)")
                .font(.body)
        }
        if let detail = viewModel.movieDetailInfo?.movieDetail {
            if let genres = detail.genres {
                Text("Genres: \(genres)")
                    .font(.body)
            }
            if let budget = detail.budget {
                Text("Budget: \(budget)")
                    .font(.body)
            }
            if let overview = detail.overview {
                Text("Overview:")
                    .multilineTextAlignment(.leading)
                    .font(.body.bold())
                Text(overview)
                    .font(.body)
            }
        } else {
            ProgressView()
        }
    }
    
    private var image: some View {
        ThumbnailView(image: $detailImage, isLoading: $viewModel.isLoading, showPlaceholder: false)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .clipped()
    }
}
