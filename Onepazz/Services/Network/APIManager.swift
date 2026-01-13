import Foundation

/// Concrete implementation of API service protocols
/// Follows Single Responsibility Principle - handles HTTP requests and token management
/// Follows Dependency Inversion Principle - depends on TokenStore abstraction
final class APIManager: APIServiceProtocol, TokenManagementProtocol {
    private let session: URLSession
    var tokenStore: TokenStore

    init(session: URLSession = .shared, tokenStore: TokenStore = InMemoryTokenStore()) {
        self.session = session
        self.tokenStore = tokenStore
    }

    func send<T: Decodable>(_ target: TargetType, as type: T.Type) async throws -> T {
        return try await request(target, as: T.self, retried: false)
    }

    func send(_ target: TargetType) async throws {
        _ = try await request(target, as: Empty.self, retried: false)
    }

    private func request<T: Decodable>(_ target: TargetType, as type: T.Type, retried: Bool) async throws -> T {
        let request = try RequestBuilder.build(target, token: tokenStore.token)
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.noData }
            switch http.statusCode {
            case 200..<300:
                if let wrapped = try? JSONDecoder().decode(APIWrapper<T>.self, from: data), let value = wrapped.data {
                    return value
                }
                if T.self == Empty.self { return Empty() as! T }
                return try JSONDecoder().decode(T.self, from: data)
            default:
                throw NetworkError.requestFailed(http.statusCode)
            }
        } catch {
            throw NetworkError.transport(error)
        }
    }

    func setToken(_ token: String?) { tokenStore.token = token }
    func setRefreshToken(_ token: String?) { tokenStore.refreshToken = token }
}

fileprivate struct Empty: Decodable { }
