import SwiftUI

extension Image {
    func thumbnail(sideHeight: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: sideHeight)
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
