import SwiftUI

/// A searchbar that can be hidden programmatically 
struct DisguisableSearchBar<S: View>: ViewModifier {
    @Binding var text: String
    @Binding var isPresented: Bool
    @ViewBuilder var suggestions: () -> S
    
    func body(content: Content) -> some View {
        if isPresented {
            viewWithSearch(content)
        } else {
            content
        }
    }
    
    @ViewBuilder
    func viewWithSearch(_ content: Content) -> some View {
        if #available(iOS 16, *) {
            content
                .searchable(text: $text)
                .searchSuggestions(suggestions)
        } else {
            content
                .searchable(text: $text, suggestions: suggestions)
        }
    }
}

extension View {
    func searchable<S>(text: Binding<String>, isPresented: Binding<Bool>, @ViewBuilder suggestions: @escaping () -> S) -> some View where S : View {
        modifier(DisguisableSearchBar(text: text, isPresented: isPresented, suggestions: suggestions))
    }
}
