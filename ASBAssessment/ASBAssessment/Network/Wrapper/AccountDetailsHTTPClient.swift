//
//  AccountDetailsHTTPClient.swift
//  ASBInterviewExercise
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Foundation

/// Http client request related protocol
protocol AccountDetailsHTTPClient {
    /// Method to create and send Request
    func sendRequest<T: Decodable>(endpoint: AccountDetailsEndPoints, responseModel: T.Type) async -> Result<T, AccountDetailsReponseErrors>
}

// AccountDetailsHTTPClient extension for request methods
extension AccountDetailsHTTPClient {

    func sendRequest<T: Decodable>(endpoint: AccountDetailsEndPoints,
                                   responseModel: T.Type) async -> Result<T, AccountDetailsReponseErrors> {
        // Create request url from end point protocol
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        // setup body
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        return await withCheckedContinuation({ checkedContinuation in
            URLSession.shared.dataTask(with: request) { responseData, response, error in
                guard let response = response as? HTTPURLResponse else {
                    return checkedContinuation.resume(returning: .failure(.noResponse))
                }
                switch response.statusCode {
                case 200...299:
                    guard let data = responseData, let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                        return checkedContinuation.resume(returning: .failure(.decode))
                    }
                    return checkedContinuation.resume(returning: .success(decodedResponse))
                case 401:
                    return checkedContinuation.resume(returning: .failure(.unauthorized))
                default:
                    return checkedContinuation.resume(returning: .failure(.unexpectedStatusCode))
                }
            }.resume()
        })
    }
}
