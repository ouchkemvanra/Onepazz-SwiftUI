//
//  SubscriptionsRepositoryProtocol.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Protocol defining subscriptions repository capabilities
/// Follows Interface Segregation Principle - focused on subscription operations only
protocol SubscriptionsRepositoryProtocol {
    func fetch() async throws -> [Subscription]
}
