import SwiftUI
import WebKit

/// For now it is a webview with readme
struct AboutPageView: View {
    
    private let readmeURL = URL(string: "https://github.com/joliejuly/MoviesApp/blob/main/README.md")!
    
    
    var body: some View {
        WebView(url: readmeURL)
    }
}
