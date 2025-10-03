import SwiftUI

/// An old fashioned onChange modifier used to avoid warnings on iOS17
@available(iOS, introduced: 15.0, deprecated: 26.0, message: "Use the built-in onChange on iOS 17.")
struct OnChange<V: Equatable>: ViewModifier {
    
    var value: V
    
    var action: (V) -> ()

    func body(content: Content) -> some View {
        
        if #available(iOS 17, *) {
            content
                .onChange(of: value) { _, newValue in
                    action(newValue)
                }
        } else {
            content
                .onChange(of: value, perform: action)
        }
    }
}

extension View {
    func onOneValueChange<V: Equatable>(of value: V, _ action: @escaping (V) -> ()) -> some View {
        modifier(OnChange(value: value, action: action))
    }
}
