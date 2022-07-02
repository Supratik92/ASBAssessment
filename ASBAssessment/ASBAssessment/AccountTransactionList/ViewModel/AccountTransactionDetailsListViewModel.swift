//
//  AccountTransactionDetailsListViewModel.swift
//  ASBAssessment
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Combine

/// AccountTransactionDetailsListViewModel for List view operations
class AccountTransactionDetailsListViewModel: ObservableObject {

    /// Property to store transaction details model array
    @Published private var transactionDetailsArray: [AccountTransactionDetailsModel] = []

    /// Property to know if screen is loading due to web request
    @Published var isScreenLoading = false

    /// Property to provide Transaction Details Array Count
    var transactionDetailsArrayCount: Int {
        return transactionDetailsArray.count
    }
}

// AccountTransactionDetailsListViewModel Service extension
extension AccountTransactionDetailsListViewModel {

    /// Function to retreive transaction details
    @MainActor
    final func retreiveAccountTransactionDetails() async throws {
        isScreenLoading = true
        let transactionResponse = await AccountDetailsService().getAccountDetailsInfo()
        switch transactionResponse {
        case .success(let responseModelArray):
            transactionDetailsArray = responseModelArray
        case .failure(let transactionError):
            throw transactionError
        }
        isScreenLoading = false
    }
}

// extension of AccountTransactionDetailsListViewModel for business logics
extension AccountTransactionDetailsListViewModel {

    /// This method returns account transaction details model
    /// - Parameter index: index of transaction array
    /// - Returns: AccountTransactionDetailsModel
    final func accountTransactionModel(for index: Int) -> AccountTransactionDetailsModel? {
        if let transaction = transactionDetailsArray[safe: index] {
            return transaction
        }
        return nil
    }
}
