import SwiftUI

struct MovieCell: View {
    let movie: Movie
    
    @StateObject private var viewModel = MovieCellViewModel()
    
    var body: some View {
        HStack(alignment: .top) {
            thumbnail
                .padding(.trailing, 16)
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
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray)
                .frame(width: 92, height: 122)
                .aspectRatio(contentMode: .fit)
            if let image = viewModel.image {
                image.thumbnail(sideHeight: 92)
            }
        }
    }
}
