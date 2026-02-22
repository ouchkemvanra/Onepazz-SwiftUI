import Foundation

struct RequestBuilder {
    static func build(_ target: TargetType, token: String?) throws -> URLRequest {
        var url = target.baseURL.appending(path: target.path)
        var request = URLRequest(url: url)
        request.httpMethod = target.httpMethod.rawValue
        var merged: HTTPHeaders = target.defaultHeaders ?? [:]
        if let h = target.headers { for (k,v) in h { merged[k] = v } }
        if let token { merged["Authorization"] = "Basic \(token)" }

        switch target.task {
        case .requestPlain:
            break
        case .requestJSONEncodable(let payload):
            if let payload {
                let wrapped = BaseBody(payload)
                request.httpBody = try JSONEncoder().encode(payload)
                merged["Content-Type"] = merged["Content-Type"] ?? "application/json"
            }
        case .requestParameters(let body, let urlParams):
            if let urlParams, !urlParams.isEmpty {
                var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) ?? URLComponents()
                var items = comps.queryItems ?? []
                for (k, v) in urlParams { items.append(URLQueryItem(name: k, value: v)) }
                comps.queryItems = items
                if let newURL = comps.url { url = newURL; request.url = newURL }
            }
            if let body {
                let wrapped = BaseBody(body)
                request.httpBody = try JSONEncoder().encode(wrapped)
                merged["Content-Type"] = merged["Content-Type"] ?? "application/json"
            }
        case .uploadMultipart(parts: let parts):
            break
        }
        for (k,v) in merged { request.setValue(v, forHTTPHeaderField: k) }
        return request
    }
}
