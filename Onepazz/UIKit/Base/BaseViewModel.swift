import Foundation
import Combine

/// A generic base ViewModel with state + input stream and a derived output publisher.
class BaseViewModel<State, Input>: ObservableObject {
    // Expose state as read-only; mutate via protected `setState`
    @Published private(set) var state: State
    let input = PassthroughSubject<Input, Never>()

    var cancellables = Set<AnyCancellable>()

    init(initial state: State) {
        self.state = state
        bindInputs()
    }

    /// Override to handle inputs -> state/effects
    func bindInputs() {
        // subclasses handle input stream
    }

    /// Protected setter for subclasses
    func setState(_ newState: State) {
        state = newState
    }

    /// AnyPublisher for external binding
    var statePublisher: AnyPublisher<State, Never> { $state.eraseToAnyPublisher() }
}