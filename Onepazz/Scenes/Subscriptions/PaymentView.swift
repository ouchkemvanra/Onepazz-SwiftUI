//
//  PaymentView.swift
//  Onepazz
//
//  Created by Claude on 1/14/26.
//

import SwiftUI

struct PaymentView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: PaymentViewModel
    let selectedPlan: SubscriptionPlan

    init(selectedPlan: SubscriptionPlan, viewModel: PaymentViewModel? = nil) {
        self.selectedPlan = selectedPlan
        self._viewModel = StateObject(wrappedValue: viewModel ?? PaymentViewModel())
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text("Payment")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                    // Bank Selection
                    VStack(spacing: 12) {
                        BankCard(
                            bankName: "Wing Bank",
                            accountNumber: "000122323",
                            isSelected: viewModel.selectedBank == .wing
                        ) {
                            viewModel.selectedBank = .wing
                        }

                        BankCard(
                            bankName: "ABA Bank",
                            accountNumber: nil,
                            isSelected: viewModel.selectedBank == .aba
                        ) {
                            viewModel.selectedBank = .aba
                        }
                    }
                    .padding(.horizontal, 16)

                    // Price Breakdown
                    VStack(spacing: 8) {
                        HStack {
                            Text("Subscription Price")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.gray)
                            Spacer()
                            Text(selectedPlan.price)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.black)
                        }

                        HStack {
                            Text("VAT")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("$0.34")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.black)
                        }

                        HStack {
                            Text("Total")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                            Text(viewModel.totalPrice)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    // Instructions
                    Text("After completing payment to above account please copy and paste Txn ID into text input below to complete the process")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.top, 24)

                    // Input Fields
                    VStack(spacing: 12) {
                        // Account Holder Name
                        HStack(spacing: 8) {
                            Text("Account Holder Name:")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.gray)

                            Text("Kemvanra Ouch")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                        // Transaction ID
                        HStack(spacing: 8) {
                            Text("Txn ID:")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.gray)

                            TextField("", text: $viewModel.transactionId)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: 80)
                }
            }

            // Pay Button
            Button {
                viewModel.processPayment(planId: selectedPlan.rawValue)
            } label: {
                Text("PAY")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .disabled(viewModel.isLoading || viewModel.transactionId.isEmpty)
            .opacity(viewModel.isLoading || viewModel.transactionId.isEmpty ? 0.5 : 1.0)
        }
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(red: 0.96, green: 0.96, blue: 0.96), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .tint(.black)
        .loadingOverlay($viewModel.isLoading, message: "Processing...")
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("Try Again") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

// MARK: - Bank Card

struct BankCard: View {
    let bankName: String
    let accountNumber: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(bankName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .black)

                    if let accountNumber = accountNumber {
                        Text(accountNumber)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
                    }
                }

                Spacer()

                if isSelected {
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 12, height: 12)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(red: 0.3, green: 0.5, blue: 0.6) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Bank Enum

enum Bank {
    case wing
    case aba
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PaymentView(selectedPlan: .standard)
    }
}
