//
//  LoginError.swift
//  Onepazz
//
//  Login-specific error types
//  Follows Single Responsibility Principle - defines login errors only
//

import Foundation

// MARK: - Login Error Types

/// Errors that can occur during login flow
/// Follows SRP - only login-related errors
enum LoginError: LocalizedError {
    case invalidPhoneNumber(String?)  // Custom message from backend
    case phoneNotRegistered(String?)
    case serverError(String)
    case networkError(Error)
    case unknown

    // MARK: - LocalizedError Implementation

    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber(let customMessage):
            // Use backend message if available, otherwise fallback
            return customMessage ?? "Please enter a valid phone number"
        case .phoneNotRegistered(let customMessage):
            return customMessage ?? "This phone number is not registered"
        case .serverError(let message):
            return message
        case .networkError(let error):
            return error.localizedDescription
        case .unknown:
            return "An unknown error occurred. Please try again."
        }
    }

    // MARK: - Factory Methods

    /// Create LoginError from API response
    /// - Parameter response: BaseResponse from API
    /// - Returns: Appropriate LoginError with backend message
    static func from<T>(_ response: BaseResponse<T>) -> LoginError {
        // Categorize by error code but always include backend message
        switch response.code {
        case 400:
            return .phoneNotRegistered(response.message)
        case 422:
            return .invalidPhoneNumber(response.message)
        case 500...599:
            return .serverError(response.message)
        default:
            return .serverError(response.message)
        }
    }

    /// Create LoginError from network error
    /// - Parameter error: Error from network call
    /// - Returns: LoginError
    static func from(_ error: Error) -> LoginError {
        return .networkError(error)
    }
}
