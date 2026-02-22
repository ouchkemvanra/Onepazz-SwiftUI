//
//  SessionManager.swift
//  Onepazz
//
//  Created by Claude on 1/13/26.
//

import Foundation
import Combine

/// Protocol for session management
/// Follows Interface Segregation Principle - separate concern from authentication
protocol SessionManagementProtocol: ObservableObject {
    var currentSession: AuthSession? { get }
    var isAuthenticated: Bool { get }

    func saveSession(_ session: AuthSession)
    func clearSession()
}

/// Session manager for authentication state
/// Follows Single Responsibility Principle - manages session state only
/// Follows Open/Closed Principle - extensible via protocol
final class SessionManager: ObservableObject, SessionManagementProtocol {
    @Published private(set) var currentSession: AuthSession?

    private let tokenManager: TokenManagementProtocol
    private let userDefaultsKey = "user_session"

    var isAuthenticated: Bool {
        currentSession != nil
    }

    init(tokenManager: TokenManagementProtocol) {
        self.tokenManager = tokenManager
        loadSession()
    }

    // MARK: - Session Management

    func saveSession(_ session: AuthSession) {
        currentSession = session

        // Save tokens
        tokenManager.setToken(session.accessToken)
        tokenManager.setRefreshToken(session.refreshToken)

        // Persist session
        if let encoded = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    func clearSession() {
        currentSession = nil

        // Clear tokens
        tokenManager.setToken(nil)
        tokenManager.setRefreshToken(nil)

        // Clear persisted session
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }

    // MARK: - Private Methods

    private func loadSession() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let session = try? JSONDecoder().decode(AuthSession.self, from: data) else {
            return
        }

        // Check if session is expired
        if session.expiresAt > Date() {
            currentSession = session
            tokenManager.setToken(session.accessToken)
            tokenManager.setRefreshToken(session.refreshToken)
        } else {
            clearSession()
        }
    }
}
