import SwiftUI

@main
struct MoviesAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MovieListView()
        }
    }
}
