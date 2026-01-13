//
//  FeaturedCard.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import SwiftUI

/// Featured content card component
/// Follows Single Responsibility Principle - displays a single featured card
/// Follows Open/Closed Principle - extensible through parameters
struct FeaturedCard: View {
    let title: String
    let imageName: String
    var badgeCount: Int? = nil
    var viewCount: String? = nil
    var hasButton: Bool = false
    let isLarge: Bool
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: width, height: height)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                )
                .clipShape(RoundedRectangle(cornerRadius: Radius.l, style: .continuous))

            // Gradient overlay
            LinearGradient(
                colors: [.black.opacity(0.6), .clear],
                startPoint: .bottom,
                endPoint: .center
            )
            .clipShape(RoundedRectangle(cornerRadius: Radius.l, style: .continuous))

            VStack(alignment: .leading, spacing: Spacing.s) {
                if let badgeCount = badgeCount, let viewCount = viewCount {
                    HStack(spacing: Spacing.s) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                            Text("\(badgeCount)")
                                .appFont(.caption)
                        }
                        .foregroundStyle(.white)

                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 10))
                            Text(viewCount)
                                .appFont(.caption)
                        }
                        .foregroundStyle(.white)
                    }
                }

                Text(title)
                    .font(.system(size: isLarge ? 28 : 20, weight: .bold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                if hasButton {
                    Button {
                        // Handle explore
                    } label: {
                        Text("Explore Now")
                            .appFont(.caption)
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, Spacing.m)
                            .padding(.vertical, Spacing.xs)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.s, style: .continuous)
                                    .fill(Color(red: 0.8, green: 0.9, blue: 0.6))
                            )
                    }
                }
            }
            .padding(Spacing.l)
        }
        .frame(width: width, height: height)
    }
}
