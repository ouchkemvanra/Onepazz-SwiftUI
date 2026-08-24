//
//  CustomTabBar.swift
//  Onepazz
//
//  Created by Claude on 2/22/26.
//  Floating pill-shaped tab bar inspired by iOS App Store design
//

import SwiftUI

// MARK: - Tab Item Model

struct TabBarItem: Identifiable {
    let id: Int
    let icon: String
    let title: String
}

// MARK: - Custom Floating Tab Bar

struct CustomTabBar: View {
    @Environment(\.theme) var theme
    @Binding var selectedTab: Int
    let onScanTapped: () -> Void

    let tabs: [TabBarItem] = [
        TabBarItem(id: 0, icon: "house.fill", title: "home".localized),
        TabBarItem(id: 1, icon: "dumbbell.fill", title: "explore".localized),
        TabBarItem(id: 2, icon: "figure.run", title: "activity".localized),
        TabBarItem(id: 3, icon: "gearshape.fill", title: "settings".localized),
        TabBarItem(id: 4, icon: "qrcode.viewfinder", title: "scan_qr".localized)
    ]

    var body: some View {
        HStack(spacing: 8) {
            // Connected pill container for first 4 tabs
            HStack(spacing: 0) {
                ForEach(tabs.prefix(4)) { tab in
                    TabPillButton(
                        tab: tab,
                        isSelected: selectedTab == tab.id,
                        isConnected: true,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = tab.id
                            }
                        }
                    )
                }
            }
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            )

            // Separate scan button - circular with black background
            Button(action: onScanTapped) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: tabs[4].icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
            }
            .buttonStyle(PillButtonStyle())
        }
        .padding(.horizontal, theme.spacing.l)
        .padding(.bottom, theme.spacing.l)
    }
}

// MARK: - Tab Pill Button

struct TabPillButton: View {
    @Environment(\.theme) var theme
    let tab: TabBarItem
    let isSelected: Bool
    let isConnected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            // Icon only
            Image(systemName: tab.icon)
                .font(.system(size: 22, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .primary : .secondary.opacity(0.6))
                .frame(width: 64, height: 56)
                .contentShape(Rectangle())
        }
        .buttonStyle(PillButtonStyle())
    }
}

// MARK: - Pill Button Style

struct PillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Tab Bar Container

struct TabBarContainer<Content: View>: View {
    @Environment(\.theme) var theme
    @Binding var selectedTab: Int
    @Binding var isTabBarVisible: Bool
    let onScanTapped: () -> Void
    let content: Content

    init(
        selectedTab: Binding<Int>,
        isTabBarVisible: Binding<Bool> = .constant(true),
        onScanTapped: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self._selectedTab = selectedTab
        self._isTabBarVisible = isTabBarVisible
        self.onScanTapped = onScanTapped
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            content

            if isTabBarVisible {
                CustomTabBar(
                    selectedTab: $selectedTab,
                    onScanTapped: onScanTapped
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isTabBarVisible)
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedTab = 0
        @State private var showScanner = false
        @State private var isTabBarVisible = true

        var body: some View {
            TabBarContainer(
                selectedTab: $selectedTab,
                isTabBarVisible: $isTabBarVisible,
                onScanTapped: {
                    showScanner = true
                }
            ) {
                ZStack {
                    // Background gradient
                    LinearGradient(
                        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()

                    VStack {
                        Text("Tab \(selectedTab)")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Button("Toggle Tab Bar") {
                            isTabBarVisible.toggle()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                }
            }
            .themed(ThemeManager())
            .sheet(isPresented: $showScanner) {
                Text("QR Scanner")
            }
        }
    }

    return PreviewWrapper()
}
