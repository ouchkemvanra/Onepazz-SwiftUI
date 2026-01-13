//
//  ActivityFilter.swift
//  Onepazz
//
//  Created by Claude on 1/7/26.
//

import Foundation

/// Activity filter enumeration
/// Follows Single Responsibility Principle - defines filter types only
enum ActivityFilter: String, CaseIterable {
    case all = "All"
    case gym = "Gym"
    case pool = "Pool"
    case badminton = "Badminton"
}
