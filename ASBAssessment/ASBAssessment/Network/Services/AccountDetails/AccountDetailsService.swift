//
//  AccountDetailsServiceable.swift
//  ASBInterviewExercise
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Foundation

/// Protocol for account detail service methods
protocol AccountDetailsServiceable {


    /// Function to retreive account details info
    /// - Returns: Result type of AccountTransactionDetailsModel and AccountDetailsRequestErrors
    func getAccountDetailsInfo() async -> Result<[AccountTransactionDetailsModel], AccountDetailsReponseErrors>
}

/// Account Detail Service 
struct AccountDetailsService: AccountDetailsHTTPClient, AccountDetailsServiceable {
    func getAccountDetailsInfo() async -> Result<[AccountTransactionDetailsModel], AccountDetailsReponseErrors> {
        return await sendRequest(endpoint: AccountDetailsEndpoint.transaction, responseModel: [AccountTransactionDetailsModel].self)
    }
}
