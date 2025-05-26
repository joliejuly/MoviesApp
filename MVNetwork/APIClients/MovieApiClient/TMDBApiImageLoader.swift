public actor TMDBApiImageLoader: ImageLoader {
    
    private let api: APIClient
    
    private var baseURL: URL
    private var imageConfig: ImageConfigurationDTO?
    
    private var loadImageTasks: [String: Task<Data, Error>] = [:]
    
    private let thumbnailCache = LRUCache<URL, Data>(capacity: 80)
    private let detailImageCache = LRUCache<URL, Data>(capacity: 15)
    
    private var language: String {
        Locale.autoupdatingCurrent.identifier
    }
    
    public init(api: APIClient, baseURL: URL = Constants.imagesBaseURL) {
        self.api = api
        self.baseURL = baseURL
    }
    
    public func fetchImage(path: String, size: ImageSize) async throws -> Data {
        
        let sizeString = getSizeString(for: size)
        
        let url = baseURL
            .appending(path: sizeString)
            .appending(path: path)
        
        let pathWithSize = url.path
        
        if
            let runningTask = loadImageTasks[pathWithSize],
            !runningTask.isCancelled {
            return try await runningTask.value
        }
        
        let task = Task {
            try await fetchImageConfigIfNeeded()
            
            let cache = (size == .small) ? thumbnailCache : detailImageCache
            
            if let cached = await cache.value(forKey: url) {
                return cached
            }
            
            let endpoint = Endpoint(path: pathWithSize)
            let data = try await api.fetchData(endpoint, baseURL: baseURL)

            await cache.insert(data, forKey: url)
            
            loadImageTasks[path] = nil
            
            return data
        }
        
        loadImageTasks[pathWithSize] = task
        
        return try await task.value
    }

    private func fetchImageConfigIfNeeded() async throws {
        guard imageConfig == nil else { return }
        let endpoint = Endpoint(path: "/configuration")
        let config = try await api.send(endpoint, type: ImageConfigurationDTO.self, baseURL: baseURL)
        self.imageConfig = config
        if let url = URL(string: config.secureBaseURL) {
            self.baseURL = url
        }
    }
    
    private func getSizeString(for size: ImageSize) -> String {
        guard
            let imageSizes = imageConfig?.posterSizes,
            imageSizes.count >= size.defaultSizeString.count
        else {
            return size.defaultSizeString
        }
                
        switch size {
            case .small:
                return imageSizes.first ?? size.defaultSizeString
            case .medium:
                return imageSizes[safe: 1] ?? size.defaultSizeString
            case .large:
                return imageSizes[safe: 3] ?? size.defaultSizeString
        }
    }
}

// Dafault poster sizes: "w92","w154","w185","w342","w500","w780","original"
private extension ImageSize {
    var defaultSizeString: String {
        switch self {
            case .small:
                return "w92"
            case .medium:
                return "w154"
            case .large:
                return "w342"
        }
    }
}
