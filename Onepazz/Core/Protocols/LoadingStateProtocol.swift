//
//  LoadingStateProtocol.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Protocol for components that can show loading state
/// Follows Interface Segregation Principle - focused on loading capability only
protocol LoadingStateProtocol {
    var isLoading: Bool { get }
}

/// Protocol for components that can show error state
/// Follows Interface Segregation Principle - separate from loading
protocol ErrorStateProtocol {
    var error: Error? { get }
}

/// Protocol for components that can show empty state
/// Follows Interface Segregation Principle - separate concern
protocol EmptyStateProtocol {
    var isEmpty: Bool { get }
}
