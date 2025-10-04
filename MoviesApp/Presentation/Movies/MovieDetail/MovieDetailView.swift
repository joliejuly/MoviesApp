import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie?
    
    @StateObject private var viewModel = MovieDetailViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                image
                details
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .task(id: movie?.id) {
                try? await viewModel.loadImage(for: movie)
            }
        }
        .padding(.horizontal, 24)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(movie?.title ?? "Movie Detail")
        .hideTabbarOnPush
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
        ThumbnailView(image: $viewModel.detailImage, isLoading: $viewModel.isLoading, showPlaceholder: false)
    }
}
