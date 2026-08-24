//
//  BaseResponse.swift
//  Onepazz
//
//  Standardized API response wrapper
//  All API responses follow this structure
//

import Foundation

// MARK: - Base Response Wrapper

/// Generic wrapper for all API responses
/// Matches the standard API format:
/// {
///   "code": 200,
///   "success": true,
///   "message": "success",
///   "data": { ... }
/// }
struct BaseResponse<T: Decodable>: Decodable {
    let code: Int
    let success: Bool
    let message: String
    let data: T?

    enum CodingKeys: String, CodingKey {
        case code
        case success
        case message
        case data
    }
}

// MARK: - Empty Response (for endpoints with no data)

struct EmptyData: Decodable {
    // Used when API returns success but no data payload
}

// MARK: - Common Response Patterns

// Success response with no data
typealias SuccessResponse = BaseResponse<EmptyData>

// MARK: - Paginated Response Wrapper

struct PaginatedData<T: Decodable>: Decodable {
    let items: [T]
    let total: Int
    let page: Int
    let pageSize: Int
    let hasMore: Bool

    enum CodingKeys: String, CodingKey {
        case items
        case total
        case page
        case pageSize = "page_size"
        case hasMore = "has_more"
    }
}

// MARK: - Usage Examples

/*

 Example 1: Simple data response
 ────────────────────────────────

 API Response:
 {
   "code": 200,
   "success": true,
   "message": "success",
   "data": {
     "phone": "087613339"
   }
 }

 Code:
 struct PhoneData: Decodable {
     let phone: String
 }

 let response = try await api.send(target, as: BaseResponse<PhoneData>.self)
 if response.success, let data = response.data {
     print(data.phone) // "087613339"
 }


 Example 2: User object response
 ────────────────────────────────

 API Response:
 {
   "code": 200,
   "success": true,
   "message": "Login successful",
   "data": {
     "id": "user_123",
     "name": "Viseth",
     "email": "viseth@example.com",
     "token": "abc123..."
   }
 }

 Code:
 struct User: Decodable {
     let id: String
     let name: String
     let email: String
     let token: String
 }

 let response = try await api.send(target, as: BaseResponse<User>.self)
 if response.success, let user = response.data {
     print(user.name)
 }


 Example 3: List/Array response
 ────────────────────────────────

 API Response:
 {
   "code": 200,
   "success": true,
   "message": "Gyms retrieved",
   "data": [
     { "id": "1", "name": "Elite Fitness" },
     { "id": "2", "name": "Gold's Gym" }
   ]
 }

 Code:
 struct Gym: Decodable {
     let id: String
     let name: String
 }

 let response = try await api.send(target, as: BaseResponse<[Gym]>.self)
 if response.success, let gyms = response.data {
     print("Found \(gyms.count) gyms")
 }


 Example 4: Paginated response
 ────────────────────────────────

 API Response:
 {
   "code": 200,
   "success": true,
   "message": "Activities retrieved",
   "data": {
     "items": [...],
     "total": 50,
     "page": 1,
     "page_size": 20,
     "has_more": true
   }
 }

 Code:
 struct Activity: Decodable {
     let id: String
     let type: String
 }

 let response = try await api.send(target, as: BaseResponse<PaginatedData<Activity>>.self)
 if response.success, let paginated = response.data {
     print(paginated.items.count)
     print(paginated.hasMore)
 }


 Example 5: Success only (no data)
 ────────────────────────────────

 API Response:
 {
   "code": 200,
   "success": true,
   "message": "Logged out successfully",
   "data": null
 }

 Code:
 let response = try await api.send(target, as: SuccessResponse.self)
 if response.success {
     print(response.message)
 }


 Example 6: Error response
 ────────────────────────────────

 API Response:
 {
   "code": 400,
   "success": false,
   "message": "Invalid phone number",
   "data": null
 }

 Code:
 let response = try await api.send(target, as: BaseResponse<User>.self)
 if !response.success {
     print("Error: \(response.message)")
 }

 */
