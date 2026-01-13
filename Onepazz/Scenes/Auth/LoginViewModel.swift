//
//  LoginViewModel.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import SwiftUI
import Combine

/// ViewModel for Login screen
/// Follows Single Responsibility Principle - manages login state and validation only
/// Follows Dependency Inversion Principle - depends on AuthRepositoryProtocol
@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var countryCode: String = "+855"
    @Published var phoneDigits: String = ""
    @Published var isLoading: Bool = false
    @Published var error: Error?

    // MARK: - Dependencies
    private let authRepository: AuthRepositoryProtocol

    // MARK: - Computed Properties
    var formattedPhone: String {
        phoneDigits.formattedAsKhPhone()
    }

    var isValid: Bool {
        phoneDigits.count >= 8
    }

    // MARK: - Initialization
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    // MARK: - Actions
    func submit() async {
        guard isValid else { return }

        isLoading = true
        error = nil

        do {
            let fullPhone = countryCode + phoneDigits
            // In production, this would request OTP
            // let _ = try await authRepository.requestOTP(phone: fullPhone)
            isLoading = false
        } catch let err {
            error = err
            isLoading = false
        }
    }
}

// MARK: - String Extensions

extension String {
    func digitsOnly() -> String {
        filter(\.isNumber)
    }

    /// Formats Cambodian-style 8–9 digits as "012 345 678" (groups of 3 from the start).
    func formattedAsKhPhone() -> String {
        let d = digitsOnly()
        guard !d.isEmpty else { return "" }
        let chars = Array(d)
        var out: [String] = []
        var i = 0
        while i < chars.count {
            let end = min(i + 3, chars.count)
            out.append(String(chars[i..<end]))
            i += 3
        }
        return out.joined(separator: " ")
    }
}
