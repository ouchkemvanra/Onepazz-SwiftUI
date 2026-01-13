//
//  HomeUser.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Home user data model
/// Follows Single Responsibility Principle - represents user data only
struct HomeUser {
    let name: String
    let avatarImage: String
    let visitsThisMonth: Int
}
