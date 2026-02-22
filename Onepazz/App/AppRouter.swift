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
                ZStack {
                    TabView(selection: $selectedTab) {
                        NavigationStack {
                            HomePageView(user: .init(name: "Viseth", avatarImage: "avatar1", visitsThisMonth: 12))
                            .tint(.blue)
                            .navigationTitle("")
                            .toolbar(.hidden, for: .navigationBar)
                        }
                        .tabItem {
                            VStack {
                                Image(systemName: "house")
                                Text("Home")
                            }
                        }
                        .tag(0)

                        NavigationStack {
                            ExploreView()
                            .tint(.blue)
                        }
                        .tabItem {
                            VStack {
                                Image(systemName: "dumbbell")
                                Text("Explore")
                            }
                        }
                        .tag(1)

                        // Empty placeholder for center button
                        Color.clear
                            .tabItem {
                                Image(systemName: "")
                            }
                            .tag(2)

                        NavigationStack {
                            ActivityView()
                            .tint(.blue)
                        }
                        .tabItem {
                            VStack {
                                Image(systemName: "figure.run")
                                Text("Activity")
                            }
                        }
                        .tag(3)

                        NavigationStack {
                            SettingsView()
                            .tint(.blue)
                        }
                        .tabItem {
                            VStack {
                                Image(systemName: "gearshape")
                                Text("More")
                            }
                        }
                        .tag(4)
                    }
                    .tint(.red)
                    .environmentObject(scanButtonVisibility)

                    // Center QR Scan Button
                    if scanButtonVisibility.isVisible {
                        VStack {
                            Spacer()
                            Button {
                                showQRScanner = true
                            } label: {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 64, height: 64)
                                    .overlay(
                                        Image(systemName: "qrcode.viewfinder")
                                            .font(.system(size: 28, weight: .medium))
                                            .foregroundColor(.white)
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                            .offset(y: -10)
                        }
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.2), value: scanButtonVisibility.isVisible)
                    }
                }
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
