import Foundation
import os

extension Bundle {
    
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
