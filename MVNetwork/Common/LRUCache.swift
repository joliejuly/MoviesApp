internal import Collections

public actor LRUCache<Key: Hashable, Value> {
    private var storage: OrderedDictionary<Key, Value> = [:]
    private let capacity: Int
    
    public init(capacity: Int? = nil) {
        if let capacity = capacity {
            self.capacity = capacity
        } else {
            let physicalMemory = ProcessInfo.processInfo.physicalMemory
            let capacity = physicalMemory / 10
            self.capacity = Int(capacity)
        }
    }
    
    public func value(forKey key: Key) -> Value? {
        guard let value = storage.removeValue(forKey: key) else { return nil }
        storage[key] = value
        return value
    }
    
    public func insert(_ value: Value, forKey key: Key) {
        storage.removeValue(forKey: key)
        storage[key] = value
        
        if storage.count > capacity {
            storage.removeFirst()
        }
    }
    
    public func removeValue(forKey key: Key) {
        storage.removeValue(forKey: key)
    }
    
    public func clear() {
        storage.removeAll()
    }
}

