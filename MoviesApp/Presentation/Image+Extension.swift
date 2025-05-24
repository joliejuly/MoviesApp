import SwiftUI

extension Image {
    func thumbnail(sideHeight: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: sideHeight, height: sideHeight)
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
