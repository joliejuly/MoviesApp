import SwiftUI

/// Main view of the app
struct RootView: View {
    @StateObject private var moviesRouter = Router<MoviesRoute>()
    @StateObject private var movies1Router = Router<MoviesRoute>()
    
    var body: some View {
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
        
    }
}
