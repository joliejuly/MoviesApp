public actor TMDBApiImageLoader: ImageLoader {
    
    private let api: APIClientProtocol
    
    private var baseURL: URL
    private var imageConfig: ImageConfigurationDTO?
    
    private var loadImageTasks: [String: Task<Data, Error>] = [:]
    
    private let thumbnailCache = LRUCache<String, Data>(capacity: 100)
    private let detailImageCache = LRUCache<String, Data>(capacity: 15)
    
    private var language: String {
        Locale.autoupdatingCurrent.identifier
    }
    
    public init(api: APIClientProtocol, baseURL: URL = Constants.imagesBaseURL) {
        self.api = api
        self.baseURL = baseURL
    }
    
    public func fetchImage(path: String, size: ImageSize) async throws -> Data {
        let sizeString = getSizeString(for: size)
        let pathWithSize = "\(sizeString)\(path)"
        
        if
            let runningTask = loadImageTasks[pathWithSize],
            !runningTask.isCancelled {
            return try await runningTask.value
        }
        
        let task = Task {
            try await fetchImageConfigIfNeeded()
            
            let cache = (size == .small) ? thumbnailCache : detailImageCache
            
            if let cached = await cache.value(forKey: pathWithSize) {
                return cached
            }
            
            let endpoint = Endpoint(path: pathWithSize)
            let data = try await api.fetchData(endpoint, baseURL: baseURL)

            await cache.insert(data, forKey: pathWithSize)
            
            loadImageTasks[path] = nil
            
            return data
        }
        
        loadImageTasks[pathWithSize] = task
        
        return try await task.value
    }
    
    public func clearCache() async {
        async let didClearThumbnails: () = thumbnailCache.clear()
        async let didClearDetails: () = detailImageCache.clear()
        _ = await (didClearThumbnails, didClearDetails)
    }

    private func fetchImageConfigIfNeeded() async throws {
        guard imageConfig == nil else { return }
        let baseURLConfiguration = Constants.baseURL
        let endpoint = Endpoint(path: "/configuration")
        let config = try await api.send(endpoint, type: ConfigurationDTO.self, baseURL: baseURLConfiguration)
        self.imageConfig = config.images
        if let url = URL(string: config.images.secureBaseUrl) {
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
