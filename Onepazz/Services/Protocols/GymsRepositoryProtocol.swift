//
//  GymsRepositoryProtocol.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Protocol defining gyms repository capabilities
/// Follows Interface Segregation Principle - focused on gym operations only
protocol GymsRepositoryProtocol {
    func fetchGyms() async throws -> [Gym]
}
