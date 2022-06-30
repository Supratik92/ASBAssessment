//
//  AccountDetailsReponseErrors.swift
//  AccountDetailsHTTPMethod
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Foundation

/// Acount Details
enum AccountDetailsReponseErrors: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown

    var customMessage: String {
        switch self {
        case .decode:
            return "Response Decoding error"
        case .unauthorized:
            return "Session unauthorized or expired"
        default:
            return "Unknown error"
        }
    }
}
