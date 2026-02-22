//
//  PaymentSuccessView.swift
//  Onepazz
//
//  Created by Claude on 2/8/26.
//

import SwiftUI

struct PaymentSuccessView: View {
    @Environment(\.dismiss) private var dismiss

    let purchaseDate: String
    let expireDate: String
    let transactionRef: String
    let subscriptionType: String
    let period: String

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Success Icon
            ZStack {
                Circle()
                    .fill(Color(red: 0.22, green: 0.31, blue: 0.35))
                    .frame(width: 160, height: 160)

                Image(systemName: "checkmark")
                    .font(.system(size: 70, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 40)

            // Title
            Text("Payment Success")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppColor.textPrimary)
                .padding(.bottom, 8)

            // Subtitle
            Text("You are now become our \(subscriptionType)")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(AppColor.textSecondary)
                .padding(.bottom, 40)

            // Transaction Details
            VStack(spacing: 12) {
                TransactionRow(label: "Purchase Date:", value: purchaseDate)
                TransactionRow(label: "Expire Date", value: expireDate)
                TransactionRow(label: "Transaction Ref:", value: transactionRef)
                TransactionRow(label: "Subscription Type:", value: subscriptionType)
                TransactionRow(label: "Period:", value: period)
            }
            .padding(.horizontal, 32)

            Spacer()

            // Done Button
            Button(action: {
                dismiss()
            }) {
                Text("Done")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(red: 0.22, green: 0.31, blue: 0.35))
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .scanButtonVisible(false)
    }
}

// MARK: - Transaction Row

struct TransactionRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(AppColor.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AppColor.textPrimary)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PaymentSuccessView(
            purchaseDate: "17.03.2025 | 05:00 pm",
            expireDate: "17.05.2025 | 12:00 am",
            transactionRef: "1231002321",
            subscriptionType: "Gold Member",
            period: "1 Month"
        )
    }
}
