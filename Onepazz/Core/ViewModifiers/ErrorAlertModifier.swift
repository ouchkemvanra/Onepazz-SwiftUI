//
//  ErrorAlertModifier.swift
//  Onepazz
//
//  Reusable error handling for SwiftUI views
//  Follows Single Responsibility Principle - only handles error display
//

import SwiftUI

// MARK: - Error Alert ViewModifier

/// ViewModifier for displaying error alerts
/// Follows SRP - handles only error alert presentation
struct ErrorAlertModifier: ViewModifier {
    @Binding var errorMessage: String?
    var title: String
    var buttonTitle: String

    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button(buttonTitle, role: .cancel) {
                    errorMessage = nil
                }
            } message: {
                if let message = errorMessage {
                    Text(message)
                }
            }
    }
}

// MARK: - View Extension

extension View {
    /// Display an error alert when errorMessage is not nil
    /// - Parameters:
    ///   - errorMessage: Binding to optional error message string
    ///   - title: Alert title (default: "Error")
    ///   - buttonTitle: Dismiss button title (default: "OK")
    /// - Returns: Modified view with error alert
    ///
    /// Example:
    /// ```swift
    /// .errorAlert($viewModel.errorMessage)
    /// .errorAlert($viewModel.errorMessage, title: "Login Failed")
    /// ```
    func errorAlert(
        _ errorMessage: Binding<String?>,
        title: String = "Error",
        buttonTitle: String = "OK"
    ) -> some View {
        modifier(ErrorAlertModifier(
            errorMessage: errorMessage,
            title: title,
            buttonTitle: buttonTitle
        ))
    }
}
