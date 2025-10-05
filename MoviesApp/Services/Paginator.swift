/// Generic pagination helper
actor Paginator<Item> {
    
    private let loadPage: (Int) async throws -> Page<Item>
    private(set) var items: [Item] = []
    private var currentPage = 1
    private var totalPages = 1
    
    private var currentTask: Task<Void, Error>?
    
    init(loadPage: @escaping (Int) async throws -> Page<Item>) {
        self.loadPage = loadPage
    }
    
    func reset() {
        items = []
        currentPage = 1
        totalPages = 1
    }
    
    func loadNextPage() async throws {
        if let currentTask, !currentTask.isCancelled {
            try await currentTask.value
        }
        
        let task = Task<Void, Error> {
            guard currentPage <= totalPages else { return }
            let page = try await loadPage(currentPage)
            items.append(contentsOf: page.items)
            totalPages = page.totalPages
            currentPage += 1
            currentTask = nil
        }
        
        currentTask = task
        
        try await task.value
    }
}
