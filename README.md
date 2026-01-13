

## UIKit Base MVC-VM (Optional)
- `UIKit/Base/BaseViewModel.swift` – generic Combine-driven VM with `state` and `input` streams
- `UIKit/Base/BaseViewController.swift` – binds to VM `statePublisher`, includes loading overlay + error alert
- Example: `UIKit/Gyms/GymsUIKitViewModel.swift`, `UIKit/Gyms/GymsViewController.swift`

Usage:
```swift
let api = APIManager()
let repo = GymsRepository(api: api)
let vm = GymsUIKitViewModel(repo: repo)
let vc = GymsViewController(viewModel: vm)
navigationController?.pushViewController(vc, animated: true)
```


## UIKit Add-ons
- `UIKit/Base/BaseTableDiffableViewController.swift` – Diffable Data Source generic base.
- `UIKit/Coordinator/Coordinator.swift` – `Coordinator` protocol + `AppCoordinator` sample that starts on Gyms screen.
- `UIKit/Bridge/SwiftUIUIKitBridge.swift` – `ViewControllerRepresentable` (UIKit in SwiftUI) + `Hosting.controller(...)` (SwiftUI in UIKit).

**Example (SwiftUI embedding UIKit):**
```swift
ViewControllerRepresentable { GymsViewController(viewModel: GymsUIKitViewModel(repo: GymsRepository(api: APIManager()))) }
```

**Example (UIKit hosting SwiftUI):**
```swift
let vc = Hosting.controller { HomeView() }
navigationController.pushViewController(vc, animated: true)
```


## Diffable CollectionView + Flow Coordinator
- `UIKit/Base/BaseCollectionDiffableViewController.swift` – Generic collection base with diffable data source.
- `UIKit/Coordinator/FlowCoordinator.swift` – `FlowCoordinator` protocol, child management, `RootFlowCoordinator` with basic deep links.

**Deep link handling:**
```swift
let coordinator = RootFlowCoordinator()
coordinator.start()
_ = coordinator.handle(.subscriptions)
```


## Transfers (Upload/Download) with Progress
**Upload (progress stream):**
```swift
let api = APIManager()
let file = Data("hello".utf8)
let target = DMSService.uploadDocument(fileName: "hello.txt", mimeType: "text/plain", data: file)
for try await progress in api.upload(target) {
    print(progress.fraction)
}
```

**Download (progress stream):**
```swift
let downloader = DownloadRepository(api: APIManager())
let url = URL(string: "https://example.com/bigfile.pdf")!
for try await p in downloader.download(url: url) {
    if let done = p.fileURL, p.fraction >= 1.0 { print("Saved at", done) }
}
```

**Multi-file upload:**
```swift
let files = [
  (fileName: "a.jpg", mimeType: "image/jpeg", data: jpegData),
  (fileName: "b.pdf", mimeType: "application/pdf", data: pdfData)
]
let meta = ["folder": "inbox"]
let target = DMSService.uploadDocuments(files: files, meta: meta)
for try await p in api.upload(target) { /* handle progress */ }
```


## UI Progress & Background Transfers

### SwiftUI HUD
```swift
@StateObject var uploader = UploadProgressController()
@State private var showHUD = false

var body: some View {
  VStack {
    Button("Upload") {
      let api = APIManager()
      let data = Data("hello".utf8)
      let target = DMSService.uploadDocument(fileName: "hello.txt", mimeType: "text/plain", data: data)
      showHUD = true
      uploader.start(stream: api.upload(target)) { _ in showHUD = false }
    }
  }
  .progressOverlay(isPresented: $showHUD, fraction: uploader.fraction, title: "Uploading…")
}
```

### UIKit HUD
```swift
let hud = showProgressHUD(title: "Uploading…")
Task {
  let api = APIManager()
  let target = /* DMSService.uploadDocument(...) */
  for try await p in api.upload(target) {
    hud.set(fraction: p.fraction)
  }
  hideProgressHUD(hud)
}
```

### Background downloads with resume
```swift
let mgr = BackgroundTransferManager.shared
let task = mgr.enqueueDownload(URL(string: "https://example.com/big.pdf")!, id: "bigpdf")

NotificationCenter.default.addObserver(forName: .BackgroundDownloadProgress, object: nil, queue: .main) { n in
  let id = n.object as? String
  let bytes = n.userInfo?["bytes"] as? Int64 ?? 0
  let total = n.userInfo?["total"] as? Int64 ?? 0
  print("progress", id ?? "-", Double(bytes)/Double(max(total,1)))
}
```

### Pause / Cancel / Resume
```swift
await BackgroundTransferManager.shared.pauseDownload(id: "bigpdf")   // stores resume data
let _ = BackgroundTransferManager.shared.enqueueDownload(URL(string:"https://example.com/big.pdf")!, id: "bigpdf") // resumes if data exists
await BackgroundTransferManager.shared.cancelDownload(id: "bigpdf")
```


### Background Uploads (SwiftUI)
```swift
let id = "upload-invoice-001"
let data = Data("invoice".utf8)
let target = DMSService.uploadDocument(fileName: "inv.pdf", mimeType: "application/pdf", data: data)
try? BackgroundTransferManager.shared.enqueueBackgroundUpload(target: target, token: AppEnvironment().apiToken, id: id)

@StateObject var transfer = BackgroundTransferObserver(id: id)
var body: some View {
  ZStack {
    // your content
    BackgroundTransferHUD(transfer)
  }
}
```
