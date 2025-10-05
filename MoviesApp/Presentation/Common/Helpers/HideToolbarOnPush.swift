import SwiftUI

/// Universal view modifier to support different swiftui APIs for hiding tabbar
struct HiddenToolbarOnPush: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .toolbarVisibility(.hidden, for: .tabBar)
        } else if #available(iOS 16, *) {
            content
                .toolbar(.hidden, for: .tabBar)
        } else {
            content
        }
    }
}

extension View {
    var hideTabbarOnPush: some View {
        modifier(HiddenToolbarOnPush())
    }
}
