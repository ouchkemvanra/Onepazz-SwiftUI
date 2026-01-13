import SwiftUI
import Combine

public struct ProgressHUD: View {
    let title: String
    let fraction: Double
    let showsPercent: Bool

    public init(title: String = "Uploading...", fraction: Double, showsPercent: Bool = true) {
        self.title = title
        self.fraction = fraction
        self.showsPercent = showsPercent
    }

    public var body: some View {
        VStack(spacing: Spacing.s) {
            ProgressView(value: fraction)
                .progressViewStyle(.linear)
            HStack {
                Text(title).appFont(Typography.subhead).foregroundStyle(AppColor.textPrimary)
                Spacer()
                if showsPercent {
                    Text("\(Int((fraction * 100).rounded()))%")
                        .appFont(Typography.subhead)
                        .foregroundStyle(AppColor.textSecondary)
                        .monospacedDigit()
                }
            }
        }
        .padding(Spacing.l)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.m, style: .continuous))
        .padding()
    }
}

public struct ProgressOverlayModifier: ViewModifier {
    @Binding var isPresented: Bool
    let fraction: Double
    let title: String

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    Spacer()
                    ProgressHUD(title: title, fraction: fraction)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.2), value: isPresented)
            }
        }
    }
}

public extension View {
    func progressOverlay(isPresented: Binding<Bool>, fraction: Double, title: String) -> some View {
        modifier(ProgressOverlayModifier(isPresented: isPresented, fraction: fraction, title: title))
    }
}

/// Bridges the AsyncThrowingStream<UploadProgress, Error> from APIManager to a simple observable object.
@MainActor
public final class UploadProgressController: ObservableObject {
    @Published public var isRunning = false
    @Published public var fraction: Double = 0

    private var task: Task<Void, Never>? = nil

    public init() { }

    func start(stream: AsyncThrowingStream<APIManager.UploadProgress, Error>,
                      onComplete: @escaping (Result<Void, Error>) -> Void = { _ in }) {
        isRunning = true
        fraction = 0
        task?.cancel()
        task = Task {
            do {
                for try await p in stream {
                    self.fraction = max(0, min(1, p.fraction))
                }
                self.isRunning = false
                onComplete(.success(()))
            } catch {
                self.isRunning = false
                onComplete(.failure(error))
            }
        }
    }

    public func cancel() {
        task?.cancel()
        isRunning = false
    }
}
