//
//  OTPVerificationView.swift
//  Onepazz
//
//  Created by Claude on 1/13/26.
//

import SwiftUI

/// OTP Verification screen
/// Follows Single Responsibility Principle - only handles UI rendering
/// Follows Dependency Inversion Principle - depends on ViewModel
struct OTPVerificationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: OTPVerificationViewModel
    @FocusState private var focusedField: Int?

    let phone: String
    let countryCode: String

    init(
        phone: String,
        countryCode: String,
        authRepository: AuthRepositoryProtocol,
        sessionManager: SessionManager
    ) {
        self.phone = phone
        self.countryCode = countryCode
        _viewModel = StateObject(wrappedValue: OTPVerificationViewModel(
            phone: phone,
            countryCode: countryCode,
            authRepository: authRepository,
            sessionManager: sessionManager
        ))
    }

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Header
                    VStack(alignment: .leading, spacing: Spacing.s) {
                        Text("verify_otp".localized)
                            .appFont(.title2)

                        Text("verify_otp_message".localized(countryCode, phone.formattedAsKhPhone()))
                            .appFont(.subhead)
                            .foregroundStyle(AppColor.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // OTP Input Fields
                    HStack(spacing: Spacing.m) {
                        ForEach(0..<6, id: \.self) { index in
                            OTPDigitField(
                                digit: binding(for: index),
                                isFocused: focusedField == index
                            )
                            .focused($focusedField, equals: index)
                        }
                    }

                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .appFont(.caption)
                            .foregroundStyle(.red)
                    }

                    // Verify button
                    Button {
                        Task { await viewModel.verifyOTP() }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("verify".localized)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.isOTPComplete || viewModel.isLoading)

                    // Resend OTP
                    HStack {
                        Text("didnt_receive_code".localized)
                            .appFont(.subhead)
                            .foregroundStyle(AppColor.textSecondary)

                        Button {
                            Task { await viewModel.resendOTP() }
                        } label: {
                            if viewModel.isResending {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else if viewModel.canResend {
                                Text("resend".localized)
                                    .appFont(.subhead)
                                    .foregroundStyle(.blue)
                            } else {
                                Text("resend_countdown".localized(viewModel.resendCountdown))
                                    .appFont(.subhead)
                                    .foregroundStyle(AppColor.textSecondary)
                            }
                        }
                        .disabled(!viewModel.canResend || viewModel.isResending)
                    }
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xxl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            focusedField = 0
            Task { await viewModel.verifyOTP() }
        }
    }

    private func binding(for index: Int) -> Binding<String> {
        Binding(
            get: { viewModel.otpDigits[index] },
            set: { newValue in
                let oldValue = viewModel.otpDigits[index]
                viewModel.otpDigits[index] = newValue

                // Trigger change handler
                DispatchQueue.main.async {
                    self.handleOTPChange(at: index, oldValue: oldValue, newValue: newValue)
                }
            }
        )
    }

    private func handleOTPChange(at index: Int, oldValue: String, newValue: String) {
        // Only allow single digit
        if newValue.count > 1 {
            viewModel.otpDigits[index] = String(newValue.suffix(1))
        }

        // Move to next field if digit entered
        if !newValue.isEmpty && index < 5 {
            focusedField = index + 1
        }

        // Move to previous field if deleted
        if newValue.isEmpty && !oldValue.isEmpty && index > 0 {
            focusedField = index - 1
        }
    }
}

// MARK: - OTP Digit Field Component
// Follows Single Responsibility Principle - handles single digit input only

private struct OTPDigitField: View {
    @Binding var digit: String
    let isFocused: Bool

    var body: some View {
        TextField("", text: $digit)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .appFont(.title2)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: Radius.m, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: Radius.m, style: .continuous)
                    .strokeBorder(isFocused ? Color.blue : Color.black.opacity(0.06), lineWidth: isFocused ? 2 : 1)
            )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        OTPVerificationView(
            phone: "012678997",
            countryCode: "+855",
            authRepository: AuthRepository(api: APIManager()),
            sessionManager: SessionManager(tokenManager: APIManager())
        )
    }
}
