//
//  VisitsCountView.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import SwiftUI

/// Visits count display component
/// Follows Single Responsibility Principle - displays monthly visit count only
struct VisitsCountView: View {
    let count: Int
    let month: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(count)")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(Color(red: 0.4, green: 0.5, blue: 0.2))

            Text("Visits in \(month)")
                .appFont(.subhead)
                .foregroundStyle(AppColor.textSecondary)
        }
    }
}
