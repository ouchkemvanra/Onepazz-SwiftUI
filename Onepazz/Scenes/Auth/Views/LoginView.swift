//
//  LoginView.swift
//  Onepazz
//
//  Created by Ouch Kemvanra on 8/25/25.
//  Refactored by Claude on 1/7/26.
//

import SwiftUI

/// Login view following SOLID principles
/// Follows Single Responsibility Principle - only handles UI rendering
/// Follows Dependency Inversion Principle - depends on LoginViewModel
struct LoginView: View {
    @EnvironmentObject var env: AppEnvironment
    @StateObject private var viewModel: LoginViewModel
    @FocusState private var focused: Bool

    init(viewModel: LoginViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? LoginViewModel(authRepository: AuthRepository(api: APIManager())))
    }

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {

                    // Title / subtitle
                    VStack(alignment: .leading, spacing: Spacing.s) {
                        Text("sign_in".localized).appFont(.title2)
                        Text("login_subtitle".localized)
                            .appFont(.subhead)
                            .foregroundStyle(AppColor.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Phone field
                    PhoneField(
                        countryCode: $viewModel.countryCode,
                        phoneDigits: $viewModel.phoneDigits,
                        placeholder: "012 678 997"
                    )
                    .focused($focused)
                    .onAppear { focused = true }

                    // Continue button
                    Button {
                        Task { await viewModel.requestOTP() }
                    } label: {
                        ZStack {
                            // Hidden text to maintain height
                            Text("continue".localized)
                                .opacity(0)

                            // Actual content
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("continue".localized)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.isValid || viewModel.isLoading)
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xxl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.shouldNavigateToOTP) {
            OTPVerificationView(
                phone: viewModel.phoneDigits,
                countryCode: viewModel.countryCode,
                authRepository: env.authRepository,
                sessionManager: env.sessionManager
            )
        }
        .errorAlert($viewModel.errorMessage)
    }
}

/// Reusable phone input field component
/// Follows Single Responsibility Principle - only handles phone input UI
private struct PhoneField: View {
    @Binding var countryCode: String
    @Binding var phoneDigits: String
    let placeholder: String

    @State private var displayText: String = ""

    var body: some View {
        HStack(spacing: Spacing.m) {
            Text(countryCode)
                .appFont(.body)
                .foregroundStyle(AppColor.textPrimary)

            Divider()
                .frame(height: 22)
                .background(Color.gray.opacity(0.3))

            TextField(placeholder, text: $displayText)
                .keyboardType(.numberPad)
                .textContentType(.telephoneNumber)
                .appFont(.body)
                .onChange(of: displayText) { newValue in
                    // Extract only digits
                    let digits = newValue.digitsOnly()

                    // Update the binding with raw digits
                    phoneDigits = digits

                    // Update display with formatted version
                    let formatted = digits.formattedAsKhPhone()
                    if formatted != displayText {
                        displayText = formatted
                    }
                }
                .onChange(of: phoneDigits) { newDigits in
                    // Sync display when phoneDigits changes externally
                    let formatted = newDigits.formattedAsKhPhone()
                    if displayText != formatted {
                        displayText = formatted
                    }
                }
                .onAppear {
                    // Initialize display text
                    displayText = phoneDigits.formattedAsKhPhone()
                }
        }
        .padding(.vertical, Spacing.m)
        .padding(.horizontal, Spacing.l)
        .frame(minHeight: 56)
        .background(
            RoundedRectangle(cornerRadius: Radius.l, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.l, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06))
        )
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AppEnvironment())
    }
}
