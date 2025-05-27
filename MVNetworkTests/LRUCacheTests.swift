import XCTest
@testable import MVNetwork

final class LRUCacheTests: XCTestCase {
    
    func test_InsertAndRetrieve() async {
        let cache = LRUCache<Int, String>(capacity: 2)
        await cache.insert("one", forKey: 1)
        let val = await cache.value(forKey: 1)!
        XCTAssertEqual(val, "one")
    }
    
    func test_EvictsLeastRecentlyUsedOnOverflow() async {
        let cache = LRUCache<Int, String>(capacity: 2)
        await cache.insert("one", forKey: 1)
        await cache.insert("two", forKey: 2)
        await cache.insert("three", forKey: 3)
        
        let val1 = await cache.value(forKey: 1)
        let val2 = await cache.value(forKey: 2)!
        let val3 = await cache.value(forKey: 3)!
        
        XCTAssertNil(val1)
        XCTAssertEqual(val2, "two")
        XCTAssertEqual(val3, "three")
    }
    
    func test_AccessMovesKeyToMostRecent() async {
        let cache = LRUCache<Int, String>(capacity: 2)
        await cache.insert("one", forKey: 1)
        await cache.insert("two", forKey: 2)
        
        let val1 = await cache.value(forKey: 1)!
        XCTAssertEqual(val1, "one")
        await cache.insert("three", forKey: 3)
        let val2 = await cache.value(forKey: 2)
        let val3 = await cache.value(forKey: 1)!
        let val4 = await cache.value(forKey: 3)!
        XCTAssertNil(val2)
        XCTAssertEqual(val3, "one")
        XCTAssertEqual(val4, "three")
    }
    
    func test_RemoveValue() async {
        let cache = LRUCache<String, Int>(capacity: 2)
        await cache.insert(42, forKey: "answer")
        let val = await cache.value(forKey: "answer")!
        XCTAssertEqual(val, 42)
        await cache.removeValue(forKey: "answer")
        let removed = await cache.value(forKey: "answer")
        XCTAssertNil(removed)
    }
    
    func test_ClearEmptiesCache() async {
        let cache = LRUCache<Int, Int>(capacity: 3)
        await cache.insert(1, forKey: 1)
        await cache.insert(2, forKey: 2)
        await cache.insert(3, forKey: 3)
        
        let preClear = await cache.value(forKey: 2)!
        XCTAssertEqual(preClear, 2)
        await cache.clear()
        let val1 = await cache.value(forKey: 1)
        let val2 = await cache.value(forKey: 2)
        let val3 = await cache.value(forKey: 3)
        XCTAssertNil(val1)
        XCTAssertNil(val2)
        XCTAssertNil(val3)
    }
}
