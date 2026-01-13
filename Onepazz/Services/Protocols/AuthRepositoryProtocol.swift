//
//  AuthRepositoryProtocol.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Protocol defining authentication repository capabilities
/// Follows Interface Segregation Principle - focused on auth operations only
protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> User
}
