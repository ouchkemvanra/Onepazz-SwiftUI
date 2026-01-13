import Foundation

struct Gym: Decodable, Hashable { let id: String; let name: String; let city: String; let isOpenNow: Bool }

/// Concrete implementation of GymsRepositoryProtocol
/// Follows Dependency Inversion Principle - depends on APIServiceProtocol abstraction
final class GymsRepository: GymsRepositoryProtocol {
    private let api: APIServiceProtocol

    init(api: APIServiceProtocol) {
        self.api = api
    }

        #if DEBUG
        func fetchGyms() async throws -> [Gym] {
            return [Gym(id:"g1", name:"Onepazz Downtown", city:"Phnom Penh", isOpenNow:true)]
        }
        #else
        func fetchGyms() async throws -> [Gym] {
            try await api.send(GymsService.list, as: [Gym].self)
        }
        #endif
    }
    