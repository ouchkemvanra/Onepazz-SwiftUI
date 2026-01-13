//
//  TargetTypeExtensions.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Extension providing default implementations for TargetType
/// Follows Open/Closed Principle - extends without requiring modification
extension TargetType {
    /// Default headers combining custom and default headers
    var allHeaders: HTTPHeaders {
        var headers = defaultHeaders ?? [:]
        if let custom = self.headers {
            headers.merge(custom) { _, new in new }
        }
        return headers
    }

    /// Default implementation for standard JSON headers
    var defaultHeaders: HTTPHeaders? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}

/// Extension for common request configurations
/// Follows Open/Closed Principle - adds capabilities without protocol changes
extension TargetType {
    /// Convenience method to get full URL with path
    var fullURL: URL {
        baseURL.appendingPathComponent(path)
    }

    /// Check if request should include authentication
    var requiresAuthentication: Bool {
        // By default, all requests require auth except login/register
        !path.contains("login") && !path.contains("register")
    }
}
