//
//  APIServiceProtocol.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Protocol defining API service capabilities
/// Follows Interface Segregation Principle - focused API operations
/// Enables Dependency Inversion Principle - high-level modules depend on this abstraction
protocol APIServiceProtocol {
    func send<T: Decodable>(_ target: TargetType, as type: T.Type) async throws -> T
    func send(_ target: TargetType) async throws
}

/// Protocol for token management
/// Follows Interface Segregation Principle - separate concern from API operations
protocol TokenManagementProtocol {
    func setToken(_ token: String?)
    func setRefreshToken(_ token: String?)
}
