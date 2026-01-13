import Foundation

enum DMSService {
    case uploadDocument(fileName: String, mimeType: String, data: Data, meta: [String: String] = [:])
}

extension DMSService: TargetType {
    var baseURL: URL { APIEnvironment.current.baseURL }
    var path: String { "/v1/dms/upload" }
    var httpMethod: HTTPMethod { .POST }
    var task: HTTPTask {
        switch self {
        case let .uploadDocument(fileName, mimeType, data, meta):
            var parts: [MultipartPart] = []
            parts.append(MultipartPart(name: "file", filename: fileName, mimeType: mimeType, data: data))
            for (k, v) in meta { parts.append(MultipartPart(name: k, data: Data(v.utf8))) }
            return .uploadMultipart(parts: parts)
        }
    }
    var headers: HTTPHeaders? { nil }
    var defaultHeaders: HTTPHeaders? { ["Accept":"application/json"] }
}

extension DMSService {
    static func uploadDocuments(files: [(fileName: String, mimeType: String, data: Data)],
                                meta: [String:String] = [:]) -> TargetType {
        struct Multi: TargetType {
            let files: [(String,String,Data)]
            let meta: [String:String]
            var baseURL: URL { APIEnvironment.current.baseURL }
            var path: String { "/v1/dms/upload" }
            var httpMethod: HTTPMethod { .POST }
            var headers: HTTPHeaders? { nil }
            var defaultHeaders: HTTPHeaders? { ["Accept":"application/json"] }
            var task: HTTPTask {
                var parts: [MultipartPart] = []
                for (name, mime, data) in files {
                    parts.append(MultipartPart(name: "files[]", filename: name, mimeType: mime, data: data))
                }
                for (k, v) in meta { parts.append(MultipartPart(name: k, data: Data(v.utf8))) }
                return .uploadMultipart(parts: parts)
            }
        }
        return Multi(files: files, meta: meta)
    }
}
