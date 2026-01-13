//
//  ViewStateRepresentable.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Protocol for view state representation
/// Follows Interface Segregation Principle - focused on state queries
protocol ViewStateRepresentable {
    associatedtype Value
    var isLoading: Bool { get }
    var value: Value? { get }
    var error: Error? { get }
}

/// Protocol for state transformations
/// Follows Interface Segregation Principle - separate transformation capability
protocol ViewStateTransformable {
    associatedtype Value
    func map<T>(_ transform: (Value) -> T) -> ViewState<T>
}

/// Extension to make ViewState conform to protocols
/// Follows Open/Closed Principle - extends without modification
extension ViewState: ViewStateRepresentable, ViewStateTransformable {}
