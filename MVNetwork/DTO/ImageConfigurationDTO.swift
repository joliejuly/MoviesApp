import Foundation

struct ConfigurationDTO: Decodable {
    let images: ImageConfigurationDTO
}

struct ImageConfigurationDTO: Decodable {
    let secureBaseUrl: String
    let posterSizes: [String]
}
