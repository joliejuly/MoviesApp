public struct PaginatedResponseDTO<ItemDTO: Decodable>: Decodable {
    public let page: Int
    public let results: [ItemDTO]
    public let totalPages: Int
    public let totalResults: Int
}
