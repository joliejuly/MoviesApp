import SwiftUI

/// Main view of the app
struct RootView: View {
    @StateObject private var moviesRouter = Router<MoviesRoute>()
    
    var body: some View {
        if #available(iOS 16, *) {
            TabView {
                MovieListView(router: moviesRouter)
                    .tabItem {
                        Label("Movies", systemImage: "popcorn")
                    }
                
                AboutPageView()
                    .tabItem {
                        Label("About", systemImage: "info.bubble.fill")
                    }
            }
        } else {
            // To support tabbar hiding on push in iOS15 a custom solution is needed
            MovieListView(router: moviesRouter)
        }
    }
}
