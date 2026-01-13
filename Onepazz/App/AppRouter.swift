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

// View modifier to hide tab bar and scan button
struct HideTabBarAndScanButtonModifier: ViewModifier {
    @EnvironmentObject var scanButtonVisibility: ScanButtonVisibility

    func body(content: Content) -> some View {
        content
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                print("🔴 Hiding scan button")
                scanButtonVisibility.isVisible = false
            }
            .onDisappear {
                print("🟢 Showing scan button")
                scanButtonVisibility.isVisible = true
            }
    }
}

extension View {
    func hideTabBarAndScanButton() -> some View {
        self.modifier(HideTabBarAndScanButtonModifier())
    }
}

struct AppRouter: View {
    @StateObject private var env = AppEnvironment()
    @StateObject private var scanButtonVisibility = ScanButtonVisibility()
    private let enableQRScan = true  // Toggle this to show/hide QR scan button
    @State private var showQRScanner = false
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    HomePageView(user: .init(name: "Viseth", avatarImage: "avatar1", visitsThisMonth: 12))
                    .tint(.blue)
                    .navigationTitle("")
                    .navigationBarHidden(true)
                }
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

                NavigationStack {
                    ExploreView()
                    .tint(.blue)
                }
                .tabItem { Label("Explore", systemImage: "dumbbell") }
                .tag(1)

                if enableQRScan {
                    Color.clear
                        .tabItem {
                            Image(systemName: "")
                                .environment(\.symbolVariants, .none)
                        }
                        .tag(2)
                }

                NavigationStack {
                    ActivityView()
                    .tint(.blue)
                }
                .tabItem { Label("Activity", systemImage: "figure.run") }
                .tag(3)

                NavigationStack {
                    SettingsView()
                    .tint(.blue)
                }
                .tabItem { Label("More", systemImage: "gearshape") }
                .tag(4)
            }
            .tint(.red)
            .environmentObject(scanButtonVisibility)
            .background(TabBarAccessor(callback: { isHidden in
                handleTabBarVisibilityChange(isHidden: isHidden)
            }))

            if enableQRScan && scanButtonVisibility.isVisible {
                VStack {
                    Spacer()
                    Button {
                        showQRScanner = true
                    } label: {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: "qrcode.viewfinder")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.bottom, 20)
                }
                .allowsHitTesting(true)
                .transition(.scale.combined(with: .opacity))
                .animation(.easeInOut(duration: 0.2), value: scanButtonVisibility.isVisible)
            }
        }
        .sheet(isPresented: $showQRScanner) {
            QRScannerView()
        }
    }

    private func handleTabBarVisibilityChange(isHidden: Bool) {
        print("📊 TabBar visibility changed: isHidden = \(isHidden)")
        if isHidden {
            // Tab bar hidden, hide button immediately
            scanButtonVisibility.isVisible = false
            print("❌ QR button hidden immediately")
        } else {
            // Tab bar visible, show button after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.scanButtonVisibility.isVisible = true
                print("✅ QR button shown after delay")
            }
        }
    }
}

// Helper to access and observe UITabBar
struct TabBarAccessor: UIViewControllerRepresentable {
    let callback: (Bool) -> Void

    func makeUIViewController(context: Context) -> TabBarObserverViewController {
        let vc = TabBarObserverViewController()
        vc.onTabBarVisibilityChange = callback
        return vc
    }

    func updateUIViewController(_ uiViewController: TabBarObserverViewController, context: Context) {
        uiViewController.checkTabBarVisibility()
    }
}

class TabBarObserverViewController: UIViewController {
    var onTabBarVisibilityChange: ((Bool) -> Void)?
    private var displayLink: CADisplayLink?
    private var lastReportedHiddenState: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupObserver()
    }

    private func setupObserver() {
        guard displayLink == nil else { return }

        displayLink = CADisplayLink(target: self, selector: #selector(checkTabBar))
        displayLink?.add(to: .main, forMode: .common)

        // Initial check
        checkTabBar()
    }

    @objc private func checkTabBar() {
        if let tabBar = tabBarController?.tabBar {
            // Check if tab bar is hidden or moved off-screen or has low alpha
            let isOffScreen = tabBar.frame.origin.y >= UIScreen.main.bounds.height
            let isTransparent = tabBar.alpha < 0.01
            let isHidden = tabBar.isHidden || isOffScreen || isTransparent

            // Only notify if state changed
            if lastReportedHiddenState != isHidden {
                lastReportedHiddenState = isHidden
                print("📊 TabBar state changed: isHidden = \(isHidden), y = \(tabBar.frame.origin.y), alpha = \(tabBar.alpha)")
                onTabBarVisibilityChange?(isHidden)
            }
        }
    }

    func checkTabBarVisibility() {
        checkTabBar()
    }

    deinit {
        displayLink?.invalidate()
        displayLink = nil
    }
}

#Preview {
    AppRouter()
}
