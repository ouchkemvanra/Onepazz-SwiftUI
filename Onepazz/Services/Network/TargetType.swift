import Foundation

// MARK: - Basic Types
public enum HTTPMethod: String { case GET, POST, PUT, PATCH, DELETE }
public typealias HTTPHeaders = [String: String]

// Helper to erase Encodable to AnyEncodable
public struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode(to:)
    }
    public func encode(to encoder: Encoder) throws { try _encode(encoder) }
}

// Base parameters injected into every request body
public struct BaseParams: Encodable {
    public let appVersion: String
    public let platform: String
    public let locale: String
    public init(appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0",
                platform: String = "iOS",
                locale: String = Locale.current.identifier) {
        self.appVersion = appVersion
        self.platform = platform
        self.locale = locale
    }
}

// Unified JSON body shape: { "base": BaseParams, "payload": ... }
public struct BaseBody: Encodable {
    public let base: BaseParams
    public let payload: AnyEncodable?
    public init(_ payload: AnyEncodable?, base: BaseParams = BaseParams()) {
        self.base = base
        self.payload = payload
    }
}

// Multipart part
public struct MultipartPart {
    public let name: String
    public let filename: String?
    public let mimeType: String?
    public let data: Data
    public init(name: String, filename: String? = nil, mimeType: String? = nil, data: Data) {
        self.name = name; self.filename = filename; self.mimeType = mimeType; self.data = data
    }
}

// Tasks
public enum HTTPTask {
    case requestPlain
    case requestJSONEncodable(AnyEncodable?)
    case requestParameters(body: AnyEncodable?, url: [String: String]?)
    case uploadMultipart(parts: [MultipartPart])
}

// MARK: - TargetType
public protocol TargetType {
  var baseURL: URL { get }
  var path: String { get }
  var httpMethod: HTTPMethod { get }
  var task: HTTPTask { get }
  var headers: HTTPHeaders? { get }
  var defaultHeaders: HTTPHeaders? { get }
}