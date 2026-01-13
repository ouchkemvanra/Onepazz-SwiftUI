//
//  ValidationExtensions.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Common validation extensions
/// Follows Open/Closed Principle - provides reusable validation without modifying types
extension String {
    /// Extracts only digit characters from string
//    func digitsOnly() -> String {
//        filter(\.isNumber)
//    }

    /// Validates email format
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }

    /// Validates phone number (Cambodian format)
    var isValidKhmerPhone: Bool {
        let cleaned = digitsOnly()
        return cleaned.count >= 8 && cleaned.count <= 10
    }

    /// Validates password strength
    var isStrongPassword: Bool {
        count >= 8 &&
        contains(where: { $0.isUppercase }) &&
        contains(where: { $0.isLowercase }) &&
        contains(where: { $0.isNumber })
    }
}

/// Validation result type
/// Follows Single Responsibility Principle - represents validation outcome
enum ValidationResult {
    case valid
    case invalid(String)

    var isValid: Bool {
        if case .valid = self { return true }
        return false
    }

    var errorMessage: String? {
        if case .invalid(let message) = self { return message }
        return nil
    }
}
