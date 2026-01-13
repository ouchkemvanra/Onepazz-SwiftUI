//
//  WelcomeHeaderView.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import SwiftUI

/// Welcome header component
/// Follows Single Responsibility Principle - displays user welcome section only
struct WelcomeHeaderView: View {
    let user: HomeUser

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome")
                    .appFont(.title2)
                    .foregroundStyle(AppColor.textPrimary)

                HStack(spacing: 4) {
                    Text("👋")
                    Text(user.name)
                        .appFont(.body)
                        .foregroundStyle(AppColor.textPrimary)
                }
            }

            Spacer()

            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray.opacity(0.5))
                )
                .overlay(
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                )
        }
    }
}
