import Foundation

public struct APIErrorBody: Decodable, Equatable { let code: Int?; let message: String?; let errors: [String:String]? }
