import SwiftUI

/// Movie poster wrapper. Is used both in movie cell and movie detail. Shows loading progress and a placeholder if needed.
struct ThumbnailView: View {
    
    @Binding var image: Image?
    @Binding var isLoading: Bool
    
    let showPlaceholder: Bool
    let aspectRatio: CGFloat = 82/120
    let cornerRadius: CGFloat = 8
    
    var body: some View {
        ZStack {
            if showPlaceholder, image == nil {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray)
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(20)
            }
            
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .mask(
                        RoundedRectangle(cornerRadius: cornerRadius)
                    )
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .onDisappear {
            image = nil
        }
    }
}
