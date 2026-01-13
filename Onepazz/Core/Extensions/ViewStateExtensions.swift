//
//  ViewStateExtensions.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Extension providing default behavior for ViewState
/// Follows Open/Closed Principle - extends functionality without modifying ViewState
extension ViewState {
    /// Convenience method to check if state is idle
    var isIdle: Bool {
        if case .idle = self { return true }
        return false
    }

    /// Convenience method to check if state is empty
    var isEmpty: Bool {
        if case .empty = self { return true }
        return false
    }

    /// Convenience method to check if state has error
    var hasError: Bool {
        if case .failed = self { return true }
        return false
    }

    /// Convenience method to check if state has data
    var hasData: Bool {
        if case .loaded = self { return true }
        return false
    }
}

/// Extension for common transformations
/// Follows Open/Closed Principle - adds new capabilities without modification
extension ViewState {
    /// Flat map for chaining transformations
    func flatMap<T>(_ transform: (Value) -> ViewState<T>) -> ViewState<T> {
        switch self {
        case .idle: return .idle
        case .loading: return .loading
        case .loaded(let v): return transform(v)
        case .empty: return .empty
        case .failed(let e): return .failed(e)
        }
    }

    /// Recover from error with default value
    func recover(with defaultValue: Value) -> ViewState<Value> {
        if case .failed = self {
            return .loaded(defaultValue)
        }
        return self
    }
}
