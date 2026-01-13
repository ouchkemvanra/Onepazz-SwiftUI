//
//  CacheableProtocol.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Protocol for cacheable data operations
/// Follows Interface Segregation Principle - focused on caching only
protocol Cacheable {
    associatedtype CacheKey: Hashable
    associatedtype CacheValue

    func cache(_ value: CacheValue, forKey key: CacheKey)
    func getCached(forKey key: CacheKey) -> CacheValue?
    func clearCache()
}

/// Protocol for cache expiration
/// Follows Interface Segregation Principle - separate expiration logic
protocol CacheExpirable {
    var cacheExpirationInterval: TimeInterval { get }
    func isCacheExpired(for key: some Hashable) -> Bool
}
