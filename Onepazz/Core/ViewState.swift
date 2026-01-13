//
//  ViewState.swift
//  Onepazz
//
//  Created by Ouch Kemvanra on 8/25/25.
//

enum ViewState<Value> {
    case idle
    case loading
    case loaded(Value)
    case empty
    case failed(Error)

    var isLoading: Bool { if case .loading = self { return true } ; return false }
    var value: Value?   { if case .loaded(let v) = self { return v } ; return nil }
    var error: Error?   { if case .failed(let e) = self { return e } ; return nil }

    func map<T>(_ transform: (Value) -> T) -> ViewState<T> {
        switch self {
        case .idle: return .idle
        case .loading: return .loading
        case .loaded(let v): return .loaded(transform(v))
        case .empty: return .empty
        case .failed(let e): return .failed(e)
        }
    }
}
