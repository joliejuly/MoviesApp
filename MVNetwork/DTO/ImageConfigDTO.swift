import Foundation

struct ImageConfigurationDTO: Decodable {
    let secureBaseURL: String
    let posterSizes: [String]
}
