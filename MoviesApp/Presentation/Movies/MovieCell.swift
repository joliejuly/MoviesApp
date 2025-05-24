import SwiftUI

struct MovieCell: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            // image
            VStack(alignment: .leading, spacing: 12) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.originalTitle)
                    .font(.body)
            }
            Spacer()
        }
        .task(id: movie.id) {
            
        }
    }
}



