import Foundation

    enum SubscriptionsService { case list }
    extension SubscriptionsService: TargetType {
        var baseURL: URL { APIEnvironment.current.baseURL }
        var path: String { "/v1/subscriptions" }
        var httpMethod: HTTPMethod { .GET }
        var task: HTTPTask { .requestPlain }
        var headers: HTTPHeaders? { nil }
        var defaultHeaders: HTTPHeaders? { ["Accept":"application/json"] }
    }
    