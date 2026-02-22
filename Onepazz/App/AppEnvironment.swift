import Foundation
import Combine

/// Application environment managing dependencies
/// Follows Dependency Inversion Principle - depends on protocol abstractions
/// Follows Single Responsibility Principle - manages app-wide dependencies
final class AppEnvironment: ObservableObject {
    @Published var theme = ThemeManager()
    @Published var authRepository: any AuthRepositoryProtocol
    @Published var gymsService: any GymsRepositoryProtocol
    @Published var subscriptionsService: any SubscriptionsRepositoryProtocol
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }

    let sessionManager: SessionManager
    let apiManager: APIServiceProtocol & TokenManagementProtocol

    private var cancellables = Set<AnyCancellable>()

    /// Initializer supporting dependency injection for testability
    /// Follows Open/Closed Principle - can inject mocks without modifying code
    init(
        apiManager: (APIServiceProtocol & TokenManagementProtocol)? = nil,
        authRepository: (any AuthRepositoryProtocol)? = nil,
        gymsService: (any GymsRepositoryProtocol)? = nil,
        subscriptionsService: (any SubscriptionsRepositoryProtocol)? = nil,
        sessionManager: SessionManager? = nil
    ) {
        let defaultAPIManager = apiManager ?? APIManager()
        self.apiManager = defaultAPIManager

        let defaultSessionManager = sessionManager ?? SessionManager(tokenManager: defaultAPIManager)
        self.sessionManager = defaultSessionManager

        self.authRepository = authRepository ?? AuthRepository(api: defaultAPIManager)
        self.gymsService = gymsService ?? GymsRepository(api: defaultAPIManager)
        self.subscriptionsService = subscriptionsService ?? SubscriptionsRepository(api: defaultAPIManager)

        // Load onboarding state from UserDefaults
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")

        // Forward SessionManager changes to AppEnvironment
        defaultSessionManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    var apiToken: String? { nil }
    var isAuthenticated: Bool { sessionManager.isAuthenticated }
}
    
