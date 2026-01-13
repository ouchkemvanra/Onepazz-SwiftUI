//import SwiftUI
//import Combine
//
//public final class BackgroundTransferObserver: ObservableObject {
//    @Published public var fraction: Double = 0
//    @Published public var isVisible: Bool = false
//    @Published public var title: String = ""
//
//    private var cancellables = Set<AnyCancellable>()
//    private let id: String
//
//    public init(id: String) {
//        self.id = id
//        NotificationCenter.default.publisher(for: .BackgroundUploadProgress)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] n in
//                guard let self, (n.object as? String) == self.id else { return }
//                let bytes = n.userInfo?["bytes"] as? Int64 ?? 0
//                let total = n.userInfo?["total"] as? Int64 ?? 0
//                self.fraction = total > 0 ? Double(bytes) / Double(total) : 0
//                self.title = L10n.uploading
//                self.isVisible = true
//            }
//            .store(in: &cancellables)
//
//        NotificationCenter.default.publisher(for: .BackgroundDownloadProgress)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] n in
//                guard let self, (n.object as? String) == self.id else { return }
//                let bytes = n.userInfo?["bytes"] as? Int64 ?? 0
//                let total = n.userInfo?["total"] as? Int64 ?? 0
//                self.fraction = total > 0 ? Double(bytes) / Double(total) : 0
//                self.title = L10n.downloading
//                self.isVisible = true
//            }
//            .store(in: &cancellables)
//
//        NotificationCenter.default.publisher(for: .BackgroundDownloadCompleted)
//            .merge(with: NotificationCenter.default.publisher(for: .BackgroundUploadCompleted))
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] n in
//                guard let self, (n.object as? String) == self.id else { return }
//                self.fraction = 1.0
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { self.isVisible = false }
//            }
//            .store(in: &cancellables)
//
//        NotificationCenter.default.publisher(for: .BackgroundDownloadFailed)
//            .merge(with: NotificationCenter.default.publisher(for: .BackgroundUploadFailed))
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] n in
//                guard let self, (n.object as? String) == self.id else { return }
//                self.isVisible = false
//            }
//            .store(in: &cancellables)
//    }
//}
//
//public struct BackgroundTransferHUD: View {
//    @ObservedObject var obs: BackgroundTransferObserver
//    public init(_ observer: BackgroundTransferObserver) { self.obs = observer }
//    public var body: some View {
//        ProgressOverlay(isPresented: .constant(obs.isVisible), fraction: obs.fraction, title: obs.title)
//    }
//}
