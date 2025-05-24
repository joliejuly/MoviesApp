import SwiftUI

struct MovieCell: View {
    let movie: Movie
    
    var body: some View {
        Text(movie.id.description)
    }
}

