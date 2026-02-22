//
//  CheckInServiceTarget.swift
//  Onepazz
//
//  Created by Claude on 1/14/26.
//

import Foundation

struct CheckInParam: Encodable {
    let qrCode: String
}

struct CheckInResponse: Decodable, Equatable {
    let name: String
    let address: String
}

enum CheckInServiceTarget {
    case checkIn(qrCode: String)
}

extension CheckInServiceTarget: TargetType {
    var baseURL: URL { APIEnvironment.current.baseURL }

    var path: String {
        switch self {
        case .checkIn: return "/checkin"
        }
    }

    var httpMethod: HTTPMethod { .POST }

    var task: HTTPTask {
        switch self {
        case .checkIn(let qrCode):
            return .requestJSONEncodable(AnyEncodable(CheckInParam(qrCode: qrCode)))
        }
    }

    var headers: HTTPHeaders? { nil }
    var defaultHeaders: HTTPHeaders? { ["Accept": "application/json"] }
}
