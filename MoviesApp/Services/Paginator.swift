final class Paginator<Item> {
    
    private let loadPage: (Int) async throws -> Page<Item>
    private(set) var items: [Item] = []
    private var currentPage = 1
    private var totalPages = 1
    private(set) var isLoading = false
    
    init(loadPage: @escaping (Int) async throws -> Page<Item>) {
        self.loadPage = loadPage
    }
    
    func reset() {
        items = []
        currentPage = 1
        totalPages = 1
    }
    
    @MainActor
    func loadNextPage() async throws {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let page = try await loadPage(currentPage)
            items.append(contentsOf: page.items)
            totalPages = page.totalPages
            currentPage += 1
        } catch {
            // TODO: retry 
            throw error
        }
    }
}
