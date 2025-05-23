import Foundation

extension Bundle {
    
    // TODO: remove. usage: let apiKey = Bundle.main.tmdbApiKey
    var tmdbApiKey: String {
        guard
            let key = object(forInfoDictionaryKey: "TMDBApiKey") as? String,
            !key.isEmpty
        else {
            fatalError("❌ TMDBApiKey not found in Info.plist. Create a Secrets.xcconfig file and set TMDB_API_KEY as a build setting as in SecretsExample.xcconfig")
        }
        return key
    }
}
