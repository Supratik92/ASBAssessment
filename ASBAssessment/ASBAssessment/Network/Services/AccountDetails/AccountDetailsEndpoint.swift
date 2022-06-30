//
//  AccountDetailsEndpoint.swift
//  ASBInterviewExercise
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Foundation

/// Endpoint Details of Account
enum AccountDetailsEndpoint {
    /// Account Transaction Type
    case transaction
}

/// Extension of AccountDetailsEndPoints to get path, method, headers and body if available
extension AccountDetailsEndpoint: AccountDetailsEndPoints {

    var path: String {
        switch self {
        case .transaction:
            return "500f2716604dc1e8e2a3c6d31ad01830/raw/4d73acaa7caa1167676445c922835554c5572e82/test-data.json"
        }
    }

    var method: AccountDetailsHTTPMethod {
        switch self {
        case .transaction:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .transaction:
            return nil
        }
    }

    var body: [String: String]? {
        return nil
    }
}
