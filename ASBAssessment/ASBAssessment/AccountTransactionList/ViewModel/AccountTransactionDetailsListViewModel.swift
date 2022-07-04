//
//  AccountTransactionDetailsListViewModel.swift
//  ASBAssessment
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Combine
import Foundation
import SwiftUI

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

    /// Initializer of AccountTransactionDetailsListViewModel
    /// - Parameter transactionDetailsArray: AccountTransactionDetailsModel type array
    init(transactionDetailsArray: [AccountTransactionDetailsModel] = []) {
        if !transactionDetailsArray.isEmpty {
            self.transactionDetailsArray = sortTransaction(modelArray: transactionDetailsArray)
        }
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
            transactionDetailsArray = sortTransaction(modelArray: responseModelArray)
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

    /// This method helps to sort transaction array
    /// - Parameter modelArray: AccountTransactionDetailsModel array
    /// - Returns: Sorted AccountTransactionDetailsModel array
    private func sortTransaction(modelArray: [AccountTransactionDetailsModel]) -> [AccountTransactionDetailsModel] {
        return modelArray.sorted { accountTransactionModelFirst, accountTransactionModelSecond in
            if let firstDateString = accountTransactionModelFirst.transactionDate, let secondDateString = accountTransactionModelSecond.transactionDate, let firstDate = Date().dateFromString(firstDateString, format: AccountTransactionDetailsModel.transactionDateFormat), let secondDate =  Date().dateFromString(secondDateString, format: AccountTransactionDetailsModel.transactionDateFormat) {
                return firstDate > secondDate
            }
            return false
        }
    }
}
