import Foundation

    enum APIEnvironment {
        case production, staging, development
        static var current: APIEnvironment { .development }
        var baseURL: URL {
            switch self {
            case .production: return URL(string: "https://api.onepazz.com")!
            case .staging: return URL(string: "https://staging-api.onepazz.com")!
            case .development: return URL(string: "https://dev-api.onepazz.com")!
            }
        }
    }
    