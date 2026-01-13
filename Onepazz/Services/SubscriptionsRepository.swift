import Foundation

struct Subscription: Decodable, Hashable { let id: String; let name: String }

/// Concrete implementation of SubscriptionsRepositoryProtocol
/// Follows Dependency Inversion Principle - depends on APIServiceProtocol abstraction
final class SubscriptionsRepository: SubscriptionsRepositoryProtocol {
    private let api: APIServiceProtocol

    init(api: APIServiceProtocol) {
        self.api = api
    }

        #if DEBUG
        func fetch() async throws -> [Subscription] {
            return [Subscription(id:"s1", name:"Pro Monthly")]
        }
        #else
        func fetch() async throws -> [Subscription] {
            try await api.send(SubscriptionsService.list, as: [Subscription].self)
        }
        #endif
    }
    