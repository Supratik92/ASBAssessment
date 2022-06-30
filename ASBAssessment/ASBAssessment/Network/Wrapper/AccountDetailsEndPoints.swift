//
//  AccountDetailsEndPoints.swift
//  ASBInterviewExercise
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Foundation

/// Protocol to store end points related informations
protocol AccountDetailsEndPoints {
    /// Base URL of api's
    var baseURL: String { get }

    /// Relative path to append on base url
    var path: String { get }

    /// Http method like get ot post
    var method: AccountDetailsHTTPMethod { get }

    /// Header for an api request
    var header: [String: String]? { get }

    /// Body of the api request
    var body: [String: String]? { get }
}

extension AccountDetailsEndPoints {
    var baseURL: String {
        return "https://gist.githubusercontent.com/Josh-Ng/"
    }
}
