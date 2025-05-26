import UIKit
import Dependencies

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        observeMemoryWarnings()
        return true
    }
    
    private func observeMemoryWarnings() {
        @Dependency(\.movieImageLoader) var movieImageLoader

        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { _ in
            Task {
                await movieImageLoader.clearCache()
            }
        }
    }
}

