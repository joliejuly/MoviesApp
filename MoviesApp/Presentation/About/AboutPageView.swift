import SwiftUI
import WebKit

/// A simple SwiftUI wrapper around `WKWebView` for iOS below 26
struct AboutPageView: View {
    
    private let readmeURL = URL(string: "https://github.com/joliejuly/MoviesApp/blob/main/README.md")!
    
    
    var body: some View {
        NavigationView {
            WebView(url: readmeURL)
                .navigationTitle("About the app")
        }
        
    }
}
