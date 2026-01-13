import Foundation

struct User: Decodable { let id: String; let name: String; let email: String; let token: String }

/// Concrete implementation of AuthRepositoryProtocol
/// Follows Dependency Inversion Principle - depends on APIServiceProtocol abstraction
final class AuthRepository: AuthRepositoryProtocol {
    private let api: APIServiceProtocol

    init(api: APIServiceProtocol) {
        self.api = api
    }

    #if DEBUG
    func login(email: String, password: String) async throws -> User {
        let u = User(id: "u1", name: "Demo", email: email, token: "token")
        if let tokenManager = api as? TokenManagementProtocol {
            tokenManager.setToken(u.token)
            tokenManager.setRefreshToken("mock-refresh-token")
        }
        return u
    }
    #else
    func login(email: String, password: String) async throws -> User {
        let param = LoginParam(email: email, password: password)
        return try await api.send(AuthService.login(parameter: param), as: User.self)
    }
    #endif
}
    