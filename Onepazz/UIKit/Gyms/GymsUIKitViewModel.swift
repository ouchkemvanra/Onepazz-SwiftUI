import Foundation
import Combine

enum GymsInput {
    case reload
}

/// ViewModel for Gyms UIKit screen
/// Follows Dependency Inversion Principle - depends on GymsRepositoryProtocol
/// Follows Single Responsibility Principle - manages gyms list state only
final class GymsUIKitViewModel: BaseViewModel<ViewState<[Gym]>, GymsInput> {
    private let repo: GymsRepositoryProtocol

    init(repo: GymsRepositoryProtocol) {
        self.repo = repo
        super.init(initial: .idle)
    }

    override func bindInputs() {
        input
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] intent in
                guard let self else { return }
                switch intent {
                case .reload:
                    Task { await self.load() }
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func load() async {
        setState(.loading)
        do {
            let gyms = try await repo.fetchGyms()
            setState(gyms.isEmpty ? .empty : .loaded(gyms))
        } catch {
            setState(.failed(error))
        }
    }
}