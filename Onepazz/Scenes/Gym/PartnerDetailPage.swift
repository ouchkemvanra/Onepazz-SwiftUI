//
//  GymDetailView.swift
//  Onepazz
//
//  Created by Ouch Kemvanra on 9/7/25.
//

import SwiftUI

struct PartnerDetailPage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.l) {
                // Header Banner
                Image("gym_banner") // Replace with your asset
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipped()
                    .padding(.top, Spacing.m)
                
                // Gym Title
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Gym Fitness")
                        .appFont(.title2)
                    Text("Boeng Keng Kang")
                        .appFont(.subhead)
                        .foregroundStyle(AppColor.textSecondary)
                }
                .padding(.horizontal, Spacing.l)
                
                // About
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("About").appFont(.title3)
                    Text("Established in 2015, FitLife Community Gym has become a cornerstone of health and wellness in our neighborhood. Our mission is to empower individuals of all ages and fitness levels to lead healthier, more active lives.")
                        .appFont(.body)
                        .foregroundStyle(AppColor.textSecondary)
                }
                .padding(.horizontal, Spacing.l)
                
                // Facilities
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("This place offers facilities such as:").appFont(.subhead)
                    HStack(spacing: Spacing.l) {
                        FacilityItem(icon: "figure.strengthtraining.traditional", name: "Gym")
                        FacilityItem(icon: "figure.pool.swim", name: "Pool")
                        FacilityItem(icon: "drop", name: "Steam")
                        FacilityItem(icon: "flame", name: "Sauna")
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                // Address + Button
                HStack {
                    Label("#12 street 310 Boeng Keng Kong, Phnom Penh", systemImage: "mappin.and.ellipse")
                        .appFont(.footnote)
                        .foregroundStyle(AppColor.textSecondary)
                    Spacer()
                    Button("Get Direction") { /* Open Maps */ }
                        .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: Radius.l))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                .padding(.horizontal, Spacing.l)
                
                Divider().padding(.horizontal)
                
                // Class Schedule
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Class Schedule").appFont(.title3)
                    
                    ScheduleRow(title: "Yoga class", day: "Every Thursday and Friday", time: "5:30 pm – 7:00 pm")
                    ScheduleRow(title: "Jumping Class", day: "Every Mon, Wed, Fri", time: "5:30 pm – 7:00 pm")
                }
                .padding(.horizontal, Spacing.l)
                
                Divider().padding(.horizontal)
                
                // Opening Hour
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Opening Hour").appFont(.title3)
                    Text("Gym is open today").appFont(.body)
                    Text("From 6:00 am – 10:00 pm")
                        .appFont(.headline)
                    Text("On public holidays such as Khmer New Year and Pchum Ben, this place might be closed. Please check before you go.")
                        .appFont(.footnote)
                        .foregroundStyle(AppColor.textSecondary)
                }
                .padding(.horizontal, Spacing.l)
                
                Divider().padding(.horizontal)
                
                // Rating & Reviews
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Rating and Reviews").appFont(.title3)
                    
                    HStack(alignment: .top, spacing: Spacing.m) {
                        Image("user_avatar") // Replace with your asset
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tommy").appFont(.headline)
                            HStack {
                                Text("Rating: 5.0")
                                ForEach(0..<5, id: \.self) { _ in
                                    Image(systemName: "star.fill").foregroundColor(.yellow)
                                }
                            }
                            Text("I don’t have to buy more subscriptions to go to gym, swimming and tennis.")
                                .appFont(.footnote)
                                .foregroundStyle(AppColor.textSecondary)
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
            }
            .padding(.bottom, 60) // extra space at bottom
        }
        .background(AppColor.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reusable Views

struct FacilityItem: View {
    let icon: String
    let name: String
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColor.accent)
            Text(name)
                .appFont(.footnote)
        }
    }
}

struct ScheduleRow: View {
    let title: String
    let day: String
    let time: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).appFont(.headline)
            Text("Day: \(day)").appFont(.footnote)
            Text("Time: \(time)").appFont(.footnote)
        }
    }
}

#Preview {
    NavigationStack {
        PartnerDetailPage()
            .environmentObject(AppEnvironment())
    }
}
