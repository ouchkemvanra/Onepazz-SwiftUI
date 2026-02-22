//
//  RepositoryExtensions.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Extension providing default error handling for repositories
/// Follows Open/Closed Principle - extends without modifying protocol
extension AuthRepositoryProtocol {

}

/// Extension providing default error handling for gyms repository
/// Follows Open/Closed Principle - adds functionality without modification
extension GymsRepositoryProtocol {
    /// Fetch gyms with automatic retry
    func fetchGymsWithRetry(maxRetries: Int = 3) async throws -> [Gym] {
        var lastError: Error?

        for attempt in 1...maxRetries {
            do {
                return try await fetchGyms()
            } catch {
                lastError = error
                if attempt < maxRetries {
                    try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt)) * 1_000_000_000))
                }
            }
        }

        throw lastError ?? NetworkError.requestFailed(0)
    }
}
