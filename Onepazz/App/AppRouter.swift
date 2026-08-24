//
//  AppRouter.swift
//  Onepazz
//
//  Created by Ouch Kemvanra on 8/25/25.
//

import SwiftUI

// Observable class for scan button visibility
class ScanButtonVisibility: ObservableObject {
    @Published var isVisible: Bool = true
}

// View modifier to control scan button visibility
struct ScanButtonVisibilityModifier: ViewModifier {
    @EnvironmentObject var scanButtonVisibility: ScanButtonVisibility
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + (isVisible ? 0.5 : 0)) {
                    scanButtonVisibility.isVisible = isVisible
                }
            }
    }
}

extension View {
    func scanButtonVisible(_ isVisible: Bool = true) -> some View {
        self.modifier(ScanButtonVisibilityModifier(isVisible: isVisible))
    }
}

struct AppRouter: View {
    @StateObject private var env = AppEnvironment()
    @StateObject private var scanButtonVisibility = ScanButtonVisibility()
    @State private var showQRScanner = false
    @State private var showOnboarding = false
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if !env.hasCompletedOnboarding {
                OnboardingView()
                    .environmentObject(env)
            } else if env.isAuthenticated {
                TabBarContainer(
                    selectedTab: $selectedTab,
                    isTabBarVisible: $scanButtonVisibility.isVisible,
                    onScanTapped: {
                        showQRScanner = true
                    }
                ) {
                    ZStack {
                        switch selectedTab {
                        case 0:
                            NavigationStack {
                                HomePageView(user: .init(name: "Viseth", avatarImage: "avatar1", visitsThisMonth: 12))
                                    .navigationTitle("")
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                        case 1:
                            NavigationStack {
                                ExploreView()
                            }
                        case 2:
                            NavigationStack {
                                ActivityView()
                            }
                        case 3:
                            NavigationStack {
                                SettingsView()
                            }
                        default:
                            NavigationStack {
                                HomePageView(user: .init(name: "Viseth", avatarImage: "avatar1", visitsThisMonth: 12))
                                    .navigationTitle("")
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                        }
                    }
                }
                .environmentObject(scanButtonVisibility)
                .sheet(isPresented: $showQRScanner) {
                    QRScannerView()
                }
                .onAppear {
                    selectedTab = 0
                }
            } else {
                NavigationStack {
                    LoginView()
                }
            }
        }
        .environmentObject(env)
        .onChange(of: env.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                selectedTab = 0
            }
        }
    }
}

#Preview {
    AppRouter()
}
