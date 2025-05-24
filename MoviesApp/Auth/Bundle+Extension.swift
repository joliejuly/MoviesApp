import Foundation

extension Bundle {

    var tmdbApiKey: String {
        guard
            let key = object(forInfoDictionaryKey: "TMDBApiKey") as? String,
            !key.isEmpty
        else {
            fatalError("❌ TMDBApiKey not found in Info.plist. Create a Secrets.xcconfig file and set TMDB_API_KEY as a build setting as in SecretsExample.xcconfig")
        }
        return key
    }
    
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
