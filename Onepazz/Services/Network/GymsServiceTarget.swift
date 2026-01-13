import Foundation

enum GymsService {
    case list
}
extension GymsService: TargetType {
    var baseURL: URL { APIEnvironment.current.baseURL }
    var path: String { "/v1/gyms" }
    var httpMethod: HTTPMethod { .GET }
    var task: HTTPTask { .requestPlain }
    var headers: HTTPHeaders? { nil }
    var defaultHeaders: HTTPHeaders? { ["Accept":"application/json"] }
}
    
