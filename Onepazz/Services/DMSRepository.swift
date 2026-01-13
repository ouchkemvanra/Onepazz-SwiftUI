import Foundation

final class DMSRepository {
    private let api: APIManager
    init(api: APIManager) { self.api = api }
    struct DMSUploadResponse: Decodable { let id: String; let url: String? }
    func uploadDocument(data: Data, fileName: String, mimeType: String, meta: [String:String] = [:]) async throws -> DMSUploadResponse {
        try await api.send(DMSService.uploadDocument(fileName: fileName, mimeType: mimeType, data: data, meta: meta), as: DMSUploadResponse.self)
    }
}