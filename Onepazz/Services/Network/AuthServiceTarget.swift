import Foundation

struct LoginParam: Encodable { let email: String; let password: String }

enum AuthService {
    case login(parameter: LoginParam)
}
extension AuthService: TargetType {
    var baseURL: URL { APIEnvironment.current.baseURL }
    var path: String { switch self { case .login: return "/v1/auth/login" } }
    var httpMethod: HTTPMethod { .POST }
    var task: HTTPTask {
        switch self {
        case .login(let p): return .requestJSONEncodable(AnyEncodable(p))
        }
    }
    var headers: HTTPHeaders? { nil }
    var defaultHeaders: HTTPHeaders? { ["Accept":"application/json"] }
}
    
