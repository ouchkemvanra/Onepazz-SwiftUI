import Foundation

public enum NetworkError: Error, LocalizedError, Equatable {
    case noData
    case requestFailed(Int)
    case server(status: Int, body: APIErrorBody?)
    case transport(Error)

    public var errorDescription: String? {
        switch self {
        case .noData: return "No data received from server."
        case .requestFailed(let code): return "Server returned error: \(code)."
        case .server(let status, let body): return body?.message ?? "Server error (\(status))."
        case .transport(let err): return err.localizedDescription
        }
    }

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.noData, .noData): return true
        case (.requestFailed(let a), .requestFailed(let b)): return a == b
        case (.server(let a, _), .server(let b, _)): return a == b
        default: return false
        }
    }
}