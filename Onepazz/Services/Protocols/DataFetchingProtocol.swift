//
//  DataFetchingProtocol.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Protocol for data fetching operations
/// Follows Interface Segregation Principle - focused on fetching only
protocol DataFetching {
    associatedtype DataType
    func fetch() async throws -> DataType
}

/// Protocol for data refreshing operations
/// Follows Interface Segregation Principle - separate from initial fetch
protocol DataRefreshing {
    func refresh() async throws
}

/// Protocol for paginated data fetching
/// Follows Interface Segregation Principle - separate pagination concern
protocol PaginatedDataFetching: DataFetching {
    func fetchNextPage() async throws -> DataType
    var hasMorePages: Bool { get }
}
