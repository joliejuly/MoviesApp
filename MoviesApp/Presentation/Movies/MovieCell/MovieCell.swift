import SwiftUI

struct MovieCell: View {
    let movie: Movie
    
    @StateObject private var viewModel = MovieCellViewModel()
    
    var body: some View {
        HStack {
            thumbnail
            VStack(alignment: .leading, spacing: 12) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.originalTitle)
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
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray)
            if let image = viewModel.image {
                image.thumbnail(sideHeight: 92)
            }
        }
        .frame(width: 92, height: 92)
    }
}
