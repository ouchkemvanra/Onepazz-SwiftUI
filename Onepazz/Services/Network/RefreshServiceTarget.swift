import Foundation
enum RefreshService: TargetType { case refresh(token: String)
 var baseURL: URL { APIEnvironment.current.baseURL }
 var path: String { "/v1/auth/refresh" }
 var httpMethod: HTTPMethod { .POST }
 var task: HTTPTask { switch self { case .refresh(let t): return .requestJSONEncodable(AnyEncodable(["refreshToken": t])) } }
 var headers: HTTPHeaders? { nil }
 var defaultHeaders: HTTPHeaders? { ["Accept":"application/json"] }
}
struct RefreshResponse: Decodable { let accessToken: String }
