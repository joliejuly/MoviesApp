import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie?
    
    @StateObject private var viewModel = MovieDetailViewModel()
    
    var body: some View {
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .task(id: movie?.id) {
            try? await viewModel.loadDetails(for: movie)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(movie?.title ?? "Movie Detail")
    }
    
    private var image: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray)
            if let image = viewModel.movieDetailInfo?.movieImage {
                image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .frame(maxWidth: .infinity)
    }
}
