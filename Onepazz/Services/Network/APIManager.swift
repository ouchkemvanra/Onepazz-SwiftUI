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
        let request = try RequestBuilder.build(target, token: "WklNTUVSLlNUQUdJTkc6aGRnc2Y1Njk0M2hmZWRmNzYzNGdmaGpkc2dmMzQ3NTQ=")

        // Log Request
        logRequest(request)

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.noData }

            // Log Response
            logResponse(response: http, data: data)

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

    // MARK: - Logging

    private func logRequest(_ request: URLRequest) {
        print("\n🌐 ============ API REQUEST ============")
        print("📍 URL: \(request.url?.absoluteString ?? "N/A")")
        print("📤 Method: \(request.httpMethod ?? "N/A")")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("📋 Headers:")
            headers.forEach { print("   \($0.key): \($0.value)") }
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("📦 Body:")
            if let json = try? JSONSerialization.jsonObject(with: body),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print(prettyString)
            } else {
                print(bodyString)
            }
        }
        print("======================================\n")
    }

    private func logResponse(response: HTTPURLResponse, data: Data) {
        print("\n📥 ============ API RESPONSE ===========")
        print("📍 URL: \(response.url?.absoluteString ?? "N/A")")
        print("📊 Status Code: \(response.statusCode)")

        if let headers = response.allHeaderFields as? [String: Any], !headers.isEmpty {
            print("📋 Headers:")
            headers.forEach { print("   \($0.key): \($0.value)") }
        }

        if let responseString = String(data: data, encoding: .utf8) {
            print("📦 Response Body:")
            if let json = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print(prettyString)
            } else {
                print(responseString)
            }
        }
        print("======================================\n")
    }

    func setToken(_ token: String?) { tokenStore.token = token }
    func setRefreshToken(_ token: String?) { tokenStore.refreshToken = token }
}

fileprivate struct Empty: Decodable { }
