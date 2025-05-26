import SwiftUI

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
                Text(movie.title)
                    .font(.body)
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .task(id: movie.id) {
           try? await viewModel.loadImage(for: movie)
        }
    }
    
    private var thumbnail: some View {
        ThumbnailView(image: $viewModel.image)
            .frame(width: 82)
    }
}

