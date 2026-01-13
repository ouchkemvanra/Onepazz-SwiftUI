//
//  ActivityFilterChip.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import SwiftUI

/// Filter chip component for activity selection
/// Follows Single Responsibility Principle - displays filter chip only
struct HomeFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .appFont(.subhead)
                .foregroundStyle(isSelected ? .white : AppColor.textSecondary)
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.m)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(isSelected ? Color.black : Color(.systemGray6))
                )
        }
    }
}
