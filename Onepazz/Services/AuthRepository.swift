import Foundation

// MARK: - Models

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let token: String
    let phone: String?
    let refreshToken: String?
}

struct CheckPhoneData: Decodable {
    let phone: String
}

struct OTPRequestParam: Encodable {
    let phone: String
}

struct OTPVerifyParam: Encodable {
    let otp: String
    
    enum CodingKeys: String, CodingKey {
        case otp = "token_verify"
    }
    
}

struct OTPResponse: Decodable {
    let success: Bool
    let message: String
    let expiresIn: Int?
}

struct AuthResponse: Decodable {
    let user: User
    let accessToken: String
    let refreshToken: String
}

struct AuthSession: Codable {
    let user: User
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
}

// MARK: - Repository

/// Concrete implementation of AuthRepositoryProtocol
/// Follows Single Responsibility Principle - handles authentication operations only
/// Follows Dependency Inversion Principle - depends on APIServiceProtocol abstraction
final class AuthRepository: AuthRepositoryProtocol {
    private let api: APIServiceProtocol

    init(api: APIServiceProtocol) {
        self.api = api
    }

    // MARK: - Phone Check

    func checkPhone(phone: String, countryCode: String) async -> Result<CheckPhoneData, LoginError> {
        #if DEBUG
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        // Mock success response
        let mockData = CheckPhoneData(phone: "\(countryCode)\(phone)")
        return .success(mockData)

        // Uncomment to test error:
        // return .failure(.phoneNotRegistered("This phone number is not registered in our system"))
        #else
        do {
            let param = CheckPhoneParam(phone: phone)
            let response = try await api.send(
                AuthServiceTarget.checkPhone(parameter: param),
                as: BaseResponse<CheckPhoneData>.self
            )

            // Check if API call was successful
            guard response.success, let data = response.data else {
                // API returned error response with message
                print("❌ API Error: code=\(response.code), message=\(response.message)")
                return .failure(LoginError.from(response))
            }

            return .success(data)
        } catch let error as DecodingError {
            // Decoding error - API response format doesn't match our model
            print("❌ Decoding Error: \(error)")
            return .failure(.serverError("Unable to process server response"))
        } catch {
            // Network error or other error
            print("❌ Network Error: \(error.localizedDescription)")
            return .failure(LoginError.from(error))
        }
        #endif
    }

    // MARK: - OTP Flow

    func requestOTP(phone: String, countryCode: String) async throws -> OTPResponse {
        #if DEBUG
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return OTPResponse(success: true, message: "OTP sent to \(countryCode)\(phone)", expiresIn: 300)
        #else
        let param = OTPRequestParam(phone: phone)
        return try await api.send(AuthServiceTarget.requestOTP(parameter: param), as: OTPResponse.self)
        #endif
    }

    func verifyOTP(phone: String, countryCode: String, otp: String) async throws -> AuthResponse {
        #if DEBUG
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000)

        let user = User(
            id: "user_123",
            name: "Viseth Ouch",
            email: "nil",
            token: "mock_access_token_\(UUID().uuidString)",
            phone: phone,
            refreshToken: "mock_refresh_token_\(UUID().uuidString)"
        )

        return AuthResponse(
            user: user,
            accessToken: user.token,
            refreshToken: user.refreshToken ?? ""
        )
        #else
        let param = OTPVerifyParam(otp: otp)
        return try await api.send(AuthServiceTarget.verifyOTP(parameter: param), as: AuthResponse.self)
        #endif
    }

    func logout() async throws {
        #if DEBUG
        try await Task.sleep(nanoseconds: 500_000_000)
        #else
        try await api.send(AuthServiceTarget.logout)
        #endif

        // Clear tokens
        if let tokenManager = api as? TokenManagementProtocol {
            tokenManager.setToken(nil)
            tokenManager.setRefreshToken(nil)
        }
    }
}
    
