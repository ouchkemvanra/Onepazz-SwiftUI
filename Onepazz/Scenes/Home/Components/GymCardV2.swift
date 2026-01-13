//
//  GymCardV2.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import SwiftUI

/// Modern gym card component with frosted glass effect
/// Follows Single Responsibility Principle - displays gym card only
struct GymCardV2: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main gym image with overlay
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 320, height: 180)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                )
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            // Top right "FOLLOW US" badge
            VStack {
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Text("FOLLOW US")
                            .font(.system(size: 10, weight: .semibold))
                        Circle()
                            .fill(Color.white)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.red)
                            )
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.red.opacity(0.9))
                    )
                    .padding([.top, .trailing], Spacing.l)
                }
                Spacer()
            }

            // Bottom frosted glass info card
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Alpha Plus Fitness")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        Text("6:00 AM - 10:00 PM")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    // Standard Member badge
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 9))
                        Text("Standard Member")
                            .font(.system(size: 10, weight: .medium))
                            .lineLimit(1)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.black)
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .frame(width: 320, height: 180)
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
    }
}
