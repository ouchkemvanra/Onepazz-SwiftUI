import Foundation

protocol TokenStore {
    var token: String? { get set }
    var refreshToken: String? { get set }
}

final class InMemoryTokenStore: TokenStore {
    var token: String?
    var refreshToken: String?
}

// Placeholder for a Keychain-based store
final class KeychainTokenStore: TokenStore {
    private let keychain = KeychainHelper()
    var token: String? {
        get { nil }
        set { if let t = newValue { keychain.save(token: t) } }
    }
    var refreshToken: String? {
        get { nil }
        set { _ = newValue }
    }
}

// Minimal helper stub
struct KeychainHelper {
    func save(token: String) { /* no-op */ }
}