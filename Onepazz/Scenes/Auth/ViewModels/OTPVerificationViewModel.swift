//
//  OTPVerificationViewModel.swift
//  Onepazz
//
//  Created by Claude on 1/13/26.
//

import SwiftUI
import Combine

/// ViewModel for OTP verification screen
/// Follows Single Responsibility Principle - manages OTP verification state only
/// Follows Dependency Inversion Principle - depends on AuthRepositoryProtocol and SessionManagementProtocol
@MainActor
final class OTPVerificationViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var otpDigits: [String] = Array(repeating: "", count: 6)
    @Published var isLoading: Bool = false
    @Published var isResending: Bool = false
    @Published var errorMessage: String?
    @Published var isVerified: Bool = false
    @Published var resendCountdown: Int = 60
    @Published var canResend: Bool = false

    // MARK: - Dependencies
    private let authRepository: AuthRepositoryProtocol
    private let sessionManager: SessionManager
    private let phone: String
    private let countryCode: String
    private var resendTimer: Timer?

    // MARK: - Computed Properties
    var isOTPComplete: Bool {
        otpDigits.allSatisfy { !$0.isEmpty }
    }

    var otpCode: String {
        otpDigits.joined()
    }

    // MARK: - Initialization
    init(
        phone: String,
        countryCode: String,
        authRepository: AuthRepositoryProtocol,
        sessionManager: SessionManager
    ) {
        self.phone = phone
        self.countryCode = countryCode
        self.authRepository = authRepository
        self.sessionManager = sessionManager
        startResendTimer()
    }

    // MARK: - Actions

    func verifyOTP() async {
        guard isOTPComplete else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await authRepository.verifyOTP(
                phone: phone,
                countryCode: countryCode,
                otp: otpCode
            )

            // Create session
            let session = AuthSession(
                user: response.user,
                accessToken: response.accessToken,
                refreshToken: response.refreshToken,
                expiresAt: Date().addingTimeInterval(3600) // 1 hour
            )

            // Save session
            sessionManager.saveSession(session)

            // Success
            isVerified = true
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false

            // Clear OTP on error
            otpDigits = Array(repeating: "", count: 6)
        }
    }

    func resendOTP() async {
        guard canResend else { return }

        isResending = true
        errorMessage = nil

        do {
            let response = try await authRepository.requestOTP(
                phone: phone,
                countryCode: countryCode
            )

            // Reset timer
            resendCountdown = response.expiresIn ?? 60
            canResend = false
            startResendTimer()

            isResending = false
        } catch {
            errorMessage = error.localizedDescription
            isResending = false
        }
    }

    // MARK: - Private Methods

    private func startResendTimer() {
        resendTimer?.invalidate()

        resendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            Task { @MainActor in
                if self.resendCountdown > 0 {
                    self.resendCountdown -= 1
                } else {
                    self.canResend = true
                    self.resendTimer?.invalidate()
                }
            }
        }
    }

    deinit {
        resendTimer?.invalidate()
    }
}
