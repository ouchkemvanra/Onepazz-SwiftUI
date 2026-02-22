import Foundation

struct LoginParam: Encodable { let email: String; let password: String }

enum AuthServiceTarget {
    case login(parameter: LoginParam)
    case requestOTP(parameter: OTPRequestParam)
    case verifyOTP(parameter: OTPVerifyParam)
    case logout
}

extension AuthServiceTarget: TargetType {
    var baseURL: URL { APIEnvironment.current.baseURL }

    var path: String {
        switch self {
        case .login: return "/v1/auth/login"
        case .requestOTP: return "sms/send"
        case .verifyOTP: return "sms/verify"
        case .logout: return "/v1/auth/logout"
        }
    }

    var httpMethod: HTTPMethod { .POST }

    var task: HTTPTask {
        switch self {
        case .login(let p): return .requestJSONEncodable(AnyEncodable(p))
        case .requestOTP(let p): return .requestJSONEncodable(AnyEncodable(p))
        case .verifyOTP(let p): return .requestJSONEncodable(AnyEncodable(p))
        case .logout: return .requestPlain
        }
    }

    var headers: HTTPHeaders? { nil }
    var defaultHeaders: HTTPHeaders? { ["Accept": "application/json"] }
}
    
