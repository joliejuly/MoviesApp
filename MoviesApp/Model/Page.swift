/// A lightweight generic model that is used for pagination
struct Page<Item> {
    let index: Int
    let items: [Item]
    let totalPages: Int
}
