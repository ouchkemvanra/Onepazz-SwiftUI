import Foundation
import Combine

/// Application environment managing dependencies
/// Follows Dependency Inversion Principle - depends on protocol abstractions
/// Follows Single Responsibility Principle - manages app-wide dependencies
final class AppEnvironment: ObservableObject {
    @Published var theme = ThemeManager()
    @Published var authService: AuthRepositoryProtocol
    @Published var gymsService: GymsRepositoryProtocol
    @Published var subscriptionsService: SubscriptionsRepositoryProtocol

    let apiManager: APIServiceProtocol & TokenManagementProtocol

    /// Initializer supporting dependency injection for testability
    /// Follows Open/Closed Principle - can inject mocks without modifying code
    init(
        apiManager: (APIServiceProtocol & TokenManagementProtocol)? = nil,
        authService: AuthRepositoryProtocol? = nil,
        gymsService: GymsRepositoryProtocol? = nil,
        subscriptionsService: SubscriptionsRepositoryProtocol? = nil
    ) {
        let defaultAPIManager = apiManager ?? APIManager()
        self.apiManager = defaultAPIManager
        self.authService = authService ?? AuthRepository(api: defaultAPIManager)
        self.gymsService = gymsService ?? GymsRepository(api: defaultAPIManager)
        self.subscriptionsService = subscriptionsService ?? SubscriptionsRepository(api: defaultAPIManager)
    }

    var apiToken: String? { nil }
}
    