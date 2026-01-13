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
                        Text("Sign In").appFont(.title2)
                        Text("Enter the phone number that you have registered\nwith Zimmer account.")
                            .appFont(.subhead)
                            .foregroundStyle(AppColor.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Phone field
                    PhoneField(
                        countryCode: $viewModel.countryCode,
                        text: Binding(
                            get: { viewModel.formattedPhone },
                            set: { newValue in
                                viewModel.phoneDigits = newValue.digitsOnly()
                            }
                        ),
                        placeholder: "012 678 997"
                    )
                    .focused($focused)
                    .onAppear { focused = true }

                    // Continue button
                    Button {
                        Task { await viewModel.submit() }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Continue")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.isValid || viewModel.isLoading)
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xxl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            if let error = viewModel.error {
                Text(error.localizedDescription)
            }
        }
    }
}

/// Reusable phone input field component
/// Follows Single Responsibility Principle - only handles phone input UI
private struct PhoneField: View {
    @Binding var countryCode: String
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: Spacing.m) {
            Text(countryCode)
                .appFont(.body)
                .foregroundStyle(AppColor.textPrimary)

            Divider()
                .frame(height: 22)
                .background(Color.gray.opacity(0.3))

            TextField(placeholder, text: $text)
                .keyboardType(.numberPad)
                .textContentType(.telephoneNumber)
                .appFont(.body)
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
