//
//  OnboardingView.swift
//  Onepazz
//
//  Created by Claude on 1/14/26.
//

import SwiftUI

struct OnboardingPage {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    @EnvironmentObject var env: AppEnvironment
    @State private var currentPage = 0

    private let pages = [
        OnboardingPage(
            imageName: "figure.mixed.cardio",
            title: "Discover gym and sport club without needing to pay more",
            description: "Our subscription allow users to go to our partner gym and sport club base on their flexibility whether it near their home or office"
        ),
        OnboardingPage(
            imageName: "building.2.fill",
            title: "One membership, unlimited access",
            description: "Access hundreds of gyms and sport clubs with a single subscription. Work out wherever and whenever you want"
        ),
        OnboardingPage(
            imageName: "qrcode.viewfinder",
            title: "Quick QR code check-in",
            description: "Simply scan the QR code at any partner location to get instant access. No cards, no hassle"
        ),
        OnboardingPage(
            imageName: "chart.line.uptrend.xyaxis",
            title: "Track your fitness journey",
            description: "Monitor your visits, explore new locations, and achieve your fitness goals with our easy-to-use app"
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Image area
            ZStack {
                Color(red: 0.92, green: 0.92, blue: 0.92)

                Image(systemName: pages[currentPage].imageName)
                    .font(.system(size: 100, weight: .light))
                    .foregroundColor(.gray.opacity(0.5))
                    .id(currentPage)
                    .transition(.opacity)
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.6)

            // Content area
            VStack(spacing: 16) {
                Text(pages[currentPage].title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .id("title-\(currentPage)")
                    .transition(.opacity)

                Text(pages[currentPage].description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .id("description-\(currentPage)")
                    .transition(.opacity)
            }
            .padding(.top, 32)

            Spacer()

            // Bottom navigation
            HStack {
                // Skip button (hidden on last page)
                Button {
                    env.hasCompletedOnboarding = true
                } label: {
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 2)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black.opacity(0.6))
                        )
                }
                .opacity(currentPage == pages.count - 1 ? 0 : 1)

                Spacer()

                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.black : Color.gray.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }

                Spacer()

                // Next/Get Started button
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        env.hasCompletedOnboarding = true
                    }
                } label: {
                    Circle()
                        .fill(Color(red: 0.2, green: 0.6, blue: 0.86))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: currentPage == pages.count - 1 ? "checkmark" : "arrow.right")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.white)
    }
}

#Preview {
    OnboardingView()
}
