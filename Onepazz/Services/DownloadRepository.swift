import Foundation

final class DownloadRepository {
    private let api: APIManager
    init(api: APIManager) { self.api = api }

    func download(url: URL, to destination: URL? = nil) -> AsyncThrowingStream<APIManager.DownloadProgress, Error> {
        api.download(from: url, to: destination)
    }
}