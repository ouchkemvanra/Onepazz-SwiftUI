import Foundation

/// Generic decodable wrapper that matches common REST shapes:
/// { "status": "...", "message": "...", "data": T }
public struct APIWrapper<T: Decodable>: Decodable {
    public let status: String?
    public let message: String?
    public let data: T?
}