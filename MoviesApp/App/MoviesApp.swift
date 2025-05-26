import SwiftUI

@main
struct MoviesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MovieListView()
        }
    }
}
