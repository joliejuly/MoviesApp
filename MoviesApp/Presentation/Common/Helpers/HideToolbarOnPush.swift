import SwiftUI

/// An old fashioned onChange modifier used to avoid warnings on iOS17
@available(iOS, introduced: 15.0, deprecated: 26.0, message: "Use the built-in on iOS 16.")
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
                .onAppear {
                    UITabBar.appearance().isHidden = true
                }
                .onDisappear{
                    UITabBar.appearance().isHidden = false
                }
        }
    }
}

extension View {
    var hideTabbarOnPush: some View {
        modifier(HiddenToolbarOnPush())
    }
}

