import SwiftUI

extension Image {
    func thumbnail() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
