import Foundation

extension Bundle {
    
    var tmdbAccessToken: String {
        guard
            let key = object(forInfoDictionaryKey: "TMDBAccessToken") as? String,
            !key.isEmpty
        else {
            fatalError("❌ TMDBAccessToken not found in Info.plist. Create a Secrets.xcconfig file and set TMDB_ACCESS_TOKEN as a build setting as in SecretsExample.xcconfig")
        }
        return key
    }
}
