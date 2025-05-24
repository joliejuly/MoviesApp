import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie?
    
    @StateObject private var viewModel = makeDetailVM()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            if let movie {
                Text("Original title: \(movie.originalTitle)")
                    .font(.caption)
            }
            if let detail = viewModel.movieDetail {
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
            try? await viewModel.loadDetails(id: movie?.id ?? 0)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(movie?.title ?? "Movie Detail")
    }
}
