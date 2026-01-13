//import Foundation
//
///// Manages background uploads/downloads with resume support via URLSession background configuration.
//final class BackgroundTransferManager: NSObject {
//    static let shared = BackgroundTransferManager()
//
//    private lazy var session: URLSession = {
//        let cfg = URLSessionConfiguration.background(withIdentifier: "app.onepazz.bg.transfers")
//        cfg.sessionSendsLaunchEvents = true
//        cfg.isDiscretionary = false
//        return URLSession(configuration: cfg, delegate: self, delegateQueue: nil)
//    }()
//
//    private let resumeStore = ResumeStore()
//
//    // MARK: Upload
//    func enqueueUpload(_ request: URLRequest, body: Data) -> URLSessionUploadTask {
//        let task = session.uploadTask(with: request, from: body)
//        task.resume()
//        return task
//    }
//
//    // MARK: Download
//    func enqueueDownload(_ url: URL, id: String) -> URLSessionDownloadTask {
//        if let resumeData = resumeStore.loadResumeData(for: id) {
//            let task = session.downloadTask(withResumeData: resumeData)
//            task.taskDescription = id
//            task.resume()
//            return task
//        } else {
//            let task = session.downloadTask(with: url)
//            task.taskDescription = id
//            task.resume()
//            return task
//        }
//    }
//
//    func pauseDownload(id: String) async {
//        let tasks = await session.tasks
//        if let dl = tasks.downloadTasks.first(where: { $0.taskDescription == id }) {
//            dl.cancel { data in
//                if let data { self.resumeStore.saveResumeData(data, for: id) }
//            }
//        }
//    }
//
//    func cancelDownload(id: String) async {
//        let tasks = await session.tasks
//        tasks.downloadTasks
//            .filter { $0.taskDescription == id }
//            .forEach { $0.cancel() }
//        resumeStore.remove(id: id)
//    }
//}
//
//// MARK: Background Uploads
///// Enqueue a background upload using a prebuilt URLRequest (must include HTTPMethod, headers, body).
//@discardableResult
//func enqueueBackgroundUpload(request: URLRequest, id: String) -> URLSessionUploadTask {
//    var req = request
//    // Ensure method defaults to POST for uploads if missing
//    if req.httpMethod == nil { req.httpMethod = "POST" }
//    let task = session.uploadTask(with: req, from: req.httpBody ?? Data())
//    task.taskDescription = id
//    task.resume()
//    return task
//}
//
///// Convenience: build a request from TargetType via RequestBuilder and enqueue.
//@discardableResult
//func enqueueBackgroundUpload(target: TargetType, token: String?, id: String) throws -> URLSessionUploadTask {
//    let req = try RequestBuilder.build(target, token: token)
//    return enqueueBackgroundUpload(request: req, id: id)
//}
//
//extension BackgroundTransferManager: URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        // Move file to a stable temp location and post notification
//        let fm = FileManager.default
//        let dir = fm.temporaryDirectory.appendingPathComponent("downloads", isDirectory: true)
//        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
//        let dest = dir.appendingPathComponent(UUID().uuidString)
//        try? fm.removeItem(at: dest)
//        do { try fm.moveItem(at: location, to: dest) } catch { }
//        let id = downloadTask.taskDescription ?? ""
//        NotificationCenter.default.post(name: .BackgroundDownloadCompleted, object: id, userInfo: ["fileURL": dest])
//        resumeStore.remove(id: id)
//    }
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
//                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        let id = downloadTask.taskDescription ?? ""
//        NotificationCenter.default.post(name: .BackgroundDownloadProgress, object: id, userInfo: [
//            "bytes": totalBytesWritten,
//            "total": totalBytesExpectedToWrite
//        ])
//    }
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        guard let error = error as NSError? else { return }
//        let id = task.taskDescription ?? ""
//        if let resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
//            resumeStore.saveResumeData(resumeData, for: id)
//        }
//        NotificationCenter.default.post(name: .BackgroundDownloadFailed, object: id, userInfo: ["error": error])
//        return
//    }
//    // No error: treat as upload completion
//    let id = task.taskDescription ?? ""
//    NotificationCenter.default.post(name: .BackgroundUploadCompleted, object: id, userInfo: nil)
//}
//
//
//final class ResumeStore {
//    private let base: URL = FileManager.default.temporaryDirectory.appendingPathComponent("resume", isDirectory: true)
//    init() { try? FileManager.default.createDirectory(at: base, withIntermediateDirectories: true) }
//    func path(for id: String) -> URL { base.appendingPathComponent(id) }
//    func saveResumeData(_ data: Data, for id: String) { try? data.write(to: path(for: id)) }
//    func loadResumeData(for id: String) -> Data? { try? Data(contentsOf: path(for: id)) }
//    func remove(id: String) { try? FileManager.default.removeItem(at: path(for: id)) }
//}
//
//extension Notification.Name {
//    static let BackgroundDownloadProgress = Notification.Name("BackgroundDownloadProgress")
//    static let BackgroundDownloadCompleted = Notification.Name("BackgroundDownloadCompleted")
//    static let BackgroundDownloadFailed = Notification.Name("BackgroundDownloadFailed")
//    static let BackgroundUploadProgress = Notification.Name("BackgroundUploadProgress")
//    static let BackgroundUploadCompleted = Notification.Name("BackgroundUploadCompleted")
//    static let BackgroundUploadFailed = Notification.Name("BackgroundUploadFailed")
//// Upload delegate callbacks
//func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64,
//                totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//    let id = task.taskDescription ?? ""
//    NotificationCenter.default.post(name: .BackgroundUploadProgress, object: id, userInfo: [
//        "bytes": totalBytesSent,
//        "total": totalBytesExpectedToSend
//    ])
//}
//}
