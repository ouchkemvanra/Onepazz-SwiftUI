//
//  ValidationProtocol.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Protocol for validatable inputs
/// Follows Interface Segregation Principle - focused on validation only
protocol Validatable {
    var isValid: Bool { get }
}

/// Protocol for form inputs
/// Follows Interface Segregation Principle - separate from general validation
protocol FormInput: Validatable {
    var errorMessage: String? { get }
}
