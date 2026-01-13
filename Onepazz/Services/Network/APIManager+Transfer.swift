import Foundation

extension APIManager {
    // MARK: - Upload with progress
    struct UploadProgress {
        let fraction: Double  // 0.0 ... 1.0
        let bytesSent: Int64
        let totalBytesExpected: Int64
    }

    func upload(_ target: TargetType,
                retry: RetryPolicy = .default) -> AsyncThrowingStream<UploadProgress, Error> {
        AsyncThrowingStream { continuation in
            Task {
                var attempt = 0
                while true {
                    do {
                        let request = try RequestBuilder.build(target, token: tokenStore.token)
                        #if DEBUG
                        RequestLogger.logCurl(request)
                        #endif
                        // Build a session with delegate for progress
                        let delegate = UploadDelegate { bytesSent, total in
                            let frac = total > 0 ? Double(bytesSent) / Double(total) : 0
                            continuation.yield(.init(fraction: frac, bytesSent: bytesSent, totalBytesExpected: total))
                        }
                        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
                        let task = session.uploadTask(with: request, from: request.httpBody ?? Data()) { data, response, error in
                            if let error = error {
                                continuation.finish(throwing: error)
                                return
                            }
                            guard let http = response as? HTTPURLResponse else {
                                continuation.finish(throwing: NetworkError.noData); return
                            }
                            guard 200..<300 ~= http.statusCode else {
                                // Decide if retry is needed for 5xx
                                if (500..<600).contains(http.statusCode), attempt < retry.maxRetries {
                                    attempt += 1
                                    let delay = retry.delay(for: attempt)
                                    DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                                        // re-enter the loop by letting outer while retry
                                        continuation.yield(with: .success(.init(fraction: 0, bytesSent: 0, totalBytesExpected: 0)))
                                    }
                                    return
                                } else {
                                    continuation.finish(throwing: NetworkError.requestFailed(http.statusCode))
                                    return
                                }
                            }
                            continuation.finish()
                        }
                        task.resume()
                        break
                    } catch {
                        if attempt < retry.maxRetries {
                            attempt += 1
                            try? await Task.sleep(nanoseconds: UInt64(retry.delay(for: attempt) * 1_000_000_000))
                            continue
                        } else {
                            continuation.finish(throwing: error)
                            break
                        }
                    }
                }
            }
        }
    }

    // MARK: - Download with progress
    struct DownloadProgress {
        let fraction: Double
        let bytesReceived: Int64
        let totalBytesExpected: Int64
        let fileURL: URL?
    }

    func download(from url: URL,
                  to destination: URL? = nil,
                  retry: RetryPolicy = .default) -> AsyncThrowingStream<DownloadProgress, Error> {
        AsyncThrowingStream { continuation in
            Task {
                var attempt = 0
                while true {
                    let delegate = DownloadDelegate(progress: { bytes, total in
                        let frac = total > 0 ? Double(bytes) / Double(total) : 0
                        continuation.yield(.init(fraction: frac, bytesReceived: bytes, totalBytesExpected: total, fileURL: nil))
                    }, completion: { tmpURL in
                        var finalURL = tmpURL
                        if let destination {
                            do {
                                if FileManager.default.fileExists(atPath: destination.path) {
                                    try? FileManager.default.removeItem(at: destination)
                                }
                                try FileManager.default.moveItem(at: tmpURL, to: destination)
                                finalURL = destination
                            } catch {
                                continuation.finish(throwing: error); return
                            }
                        }
                        continuation.yield(.init(fraction: 1.0, bytesReceived: 0, totalBytesExpected: 0, fileURL: finalURL))
                        continuation.finish()
                    })
                    let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
                    let task = session.downloadTask(with: url) { tmpURL, response, error in
                        if let error = error {
                            if attempt < retry.maxRetries {
                                attempt += 1
                                let delay = retry.delay(for: attempt)
                                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                                    // retry by re-entering while
                                }
                                return
                            } else {
                                continuation.finish(throwing: error); return
                            }
                        }
                        guard let http = response as? HTTPURLResponse else {
                            continuation.finish(throwing: NetworkError.noData); return
                        }
                        if !(200..<300).contains(http.statusCode) {
                            if (500..<600).contains(http.statusCode), attempt < retry.maxRetries {
                                attempt += 1
                                let delay = retry.delay(for: attempt)
                                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {}
                                return
                            } else {
                                continuation.finish(throwing: NetworkError.requestFailed(http.statusCode))
                                return
                            }
                        }
                        if let tmpURL = tmpURL {
                            delegate.completion?(tmpURL)
                        } else {
                            continuation.finish(throwing: NetworkError.noData)
                        }
                    }
                    task.resume()
                    break
                }
            }
        }
    }
}

// MARK: - Delegates
final class UploadDelegate: NSObject, URLSessionTaskDelegate {
    let progress: (Int64, Int64) -> Void
    init(progress: @escaping (Int64, Int64) -> Void) { self.progress = progress }
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        progress(totalBytesSent, totalBytesExpectedToSend)
    }
}

final class DownloadDelegate: NSObject, URLSessionDownloadDelegate {
    let progress: (Int64, Int64) -> Void
    let completion: ((URL) -> Void)?
    init(progress: @escaping (Int64, Int64) -> Void, completion: ((URL) -> Void)? = nil) {
        self.progress = progress
        self.completion = completion
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress(totalBytesWritten, totalBytesExpectedToWrite)
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        completion?(location)
    }
}
