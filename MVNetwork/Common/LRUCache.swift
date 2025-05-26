internal import Collections

public actor LRUCache<Key: Hashable, Value> {
    private var storage: OrderedDictionary<Key, Value> = [:]
    private let capacity: Int
    
    public init(capacity: Int) {
        self.capacity = capacity
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

