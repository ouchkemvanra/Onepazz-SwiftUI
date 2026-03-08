//
//  AboutUsView.swift
//  Onepazz
//
//  Created by Claude on 2/8/26.
//

import SwiftUI
import MapKit

struct AboutUsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) var theme
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 11.5564, longitude: 104.9282), // Phnom Penh coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Map Section
                Map(coordinateRegion: $region, annotationItems: [MapLocation(coordinate: region.center)]) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.3))
                                .frame(width: 60, height: 60)

                            Circle()
                                .fill(Color.white)
                                .frame(width: 44, height: 44)
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

                            Image(systemName: "building.2.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                        }
                    }
                }
                .frame(height: 280)
                .disabled(true)

                // Content Section
                VStack(alignment: .leading, spacing: theme.spacing.l) {
                    Text("onepazz".localized)
                        .font(.themed(theme.typography.largeTitle))
                        .foregroundColor(Color(theme.colors.textPrimary))

                    Text("onepazz_description".localized)
                        .font(.themed(theme.typography.body))
                        .foregroundColor(Color(theme.colors.textSecondary))
                        .lineSpacing(4)

                    // Contact Us Section
                    VStack(alignment: .leading, spacing: theme.spacing.l) {
                        Text("contact_us".localized)
                            .font(.themed(theme.typography.headline))
                            .foregroundColor(Color(theme.colors.textPrimary))

                        // Call Button
                        Button(action: {
                            if let url = URL(string: "tel://012123123") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack(spacing: theme.spacing.m) {
                                Image(systemName: "phone.fill")
                                    .font(.system(size: theme.icons.small))
                                    .foregroundColor(Color(theme.colors.textPrimary))

                                Text("call".localized)
                                    .font(.themed(theme.typography.body))
                                    .foregroundColor(Color(theme.colors.textPrimary))

                                Spacer()
                            }
                            .padding(.vertical, theme.spacing.m)
                        }

                        Divider()

                        // Telegram Button
                        Button(action: {
                            if let url = URL(string: "https://t.me/onepazz") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack(spacing: theme.spacing.m) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: theme.icons.small))
                                    .foregroundColor(Color(theme.colors.textPrimary))

                                Text("telegram".localized)
                                    .font(.themed(theme.typography.body))
                                    .foregroundColor(Color(theme.colors.textPrimary))

                                Spacer()
                            }
                            .padding(.vertical, theme.spacing.m)
                        }
                    }
                    .padding(.top, theme.spacing.s)
                }
                .padding(theme.spacing.xl)
            }
        }
        .navigationTitle("about_us".localized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for:.tabBar)
        .scanButtonVisible(false) 
    }
}

// Helper struct for map annotation
struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    NavigationStack {
        AboutUsView()
    }
}
