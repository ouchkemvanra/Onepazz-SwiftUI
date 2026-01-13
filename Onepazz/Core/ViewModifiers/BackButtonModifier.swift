//
//  BackButtonModifier.swift
//  Onepazz
//
//  Created by Claude on 10/26/25.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
    }
}

extension View {
    func customBackButton() -> some View {
        modifier(BackButtonModifier())
    }
}
