//
//  AuthRepositoryProtocol.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//  Updated on 1/13/26 for OTP flow
//

import Foundation

/// Protocol defining authentication repository capabilities
/// Follows Interface Segregation Principle - focused on auth operations only
/// Follows Dependency Inversion Principle - abstracts authentication logic
protocol AuthRepositoryProtocol {
    func requestOTP(phone: String, countryCode: String) async throws -> OTPResponse
    func verifyOTP(phone: String, countryCode: String, otp: String) async throws -> AuthResponse
    func logout() async throws
}
