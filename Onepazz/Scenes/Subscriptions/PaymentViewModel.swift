//
//  PaymentViewModel.swift
//  Onepazz
//
//  Created by Claude on 1/14/26.
//

import Foundation

/// ViewModel for PaymentView
/// Follows Single Responsibility Principle - handles payment state management only
/// Follows Dependency Inversion Principle - depends on protocol abstractions
class PaymentViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var selectedBank: Bank = .wing
    @Published var transactionId: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let apiManager: APIServiceProtocol

    // MARK: - Computed Properties

    var totalPrice: String {
        // VAT calculation: price + VAT
        return "$30.23"
    }

    // MARK: - Initialization

    /// Initializer supporting dependency injection for testability
    /// Follows Open/Closed Principle - can inject mocks without modifying code
    init(apiManager: APIServiceProtocol? = nil) {
        self.apiManager = apiManager ?? APIManager()
    }

    // MARK: - Public Methods

    /// Process payment with selected bank and transaction ID
    /// Follows Single Responsibility Principle - handles payment processing only
    func processPayment(planId: String) {
        guard !transactionId.isEmpty else {
            errorMessage = "Please enter transaction ID"
            return
        }

        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                // TODO: Implement payment API call
                // let response = try await apiManager.send(
                //     PaymentServiceTarget.processPayment(
                //         planId: planId,
                //         transactionId: transactionId,
                //         bankType: selectedBank == .wing ? "wing" : "aba"
                //     ),
                //     as: PaymentResponse.self
                // )

                // Simulate API call for now
                try await Task.sleep(nanoseconds: 2_000_000_000)

                self.isLoading = false

                // Handle success - navigate or show confirmation
                print("Payment processed successfully")

            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("Payment failed: \(error)")
            }
        }
    }

    /// Reset payment state
    func reset() {
        transactionId = ""
        selectedBank = .wing
        errorMessage = nil
    }
}
