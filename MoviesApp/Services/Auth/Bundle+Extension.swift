import Foundation
import os

extension Bundle {
    
    /// Access token is stored in Secrets.xcconfig file that is not commited in the repo. See Readme.md for more info.
    /// In Info.plist is stored an alias that is resolved in runtime.
    var tmdbAccessToken: String {
        guard
            let key = object(forInfoDictionaryKey: "TMDBAccessToken") as? String,
            !key.isEmpty
        else {
            let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.yourapp.bundle", category: "Configuration")
            os_log("\n\n\n❌ TMDBAccessToken not found in Info.plist. Create a Secrets.xcconfig file and set TMDB_ACCESS_TOKEN. See SecretsExample.xcconfig for reference.\n\n\n", log: log, type: .error)
            return ""
        }
        return key
    }
}
