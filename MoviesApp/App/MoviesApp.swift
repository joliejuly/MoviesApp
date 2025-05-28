import SwiftUI
import IssueReporting

@main
struct MoviesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            if !isTesting {
                MovieListView()
            }
        }
    }
}
