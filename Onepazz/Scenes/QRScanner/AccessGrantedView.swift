//
//  AccessGrantedView.swift
//  Onepazz
//
//  Created by Claude on 1/14/26.
//

import SwiftUI

struct AccessGrantedView: View {
    @Environment(\.dismiss) var dismiss
    let gymName: String

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Checkmark circle
            ZStack {
                Circle()
                    .fill(Color(red: 0.4, green: 0.73, blue: 0.82))
                    .frame(width: 200, height: 200)

                Image(systemName: "checkmark")
                    .font(.system(size: 80, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 60)

            // Access Granted text
            Text("access_granted".localized)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.black)
                .padding(.bottom, 16)

            // Subtitle text
            Text("access_granted_message".localized(gymName))
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            // Done button
            Button {
                dismiss()
            } label: {
                Text("done".localized)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.15, green: 0.24, blue: 0.29))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.white)
    }
}

#Preview {
    AccessGrantedView(gymName: "Elite Fitness BKK")
}
