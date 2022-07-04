//
//  AccountTransactionDetailsViewModel.swift
//  ASBAssessment
//
//  Created by Banerjee, Supratik on 03/07/22.
//

import Combine

/// AccountTransactionDetailsViewModel
class AccountTransactionDetailsViewModel: ObservableObject {

    // MARK: - Properties
    @Published private var transactionDetailModel: AccountTransactionDetailsModel

    /// Transaction Details Initializer
    /// - Parameter transactionDetailModel: Transaction related details model
    init(transactionDetailModel: AccountTransactionDetailsModel) {
        self.transactionDetailModel = transactionDetailModel
    }

    // Getters for Trasnsaction Details

    /// Property to display transaction Id
    var id: Int {
        return transactionDetailModel.id ?? .zero
    }

    /// Property to verify if it is a credit ot debit transaction
    var isDebit: Bool {
        return transactionDetailModel.isDebited == true
    }

    /// Property to display transaction summary
    var summary: String {
        return transactionDetailModel.summary ?? .emptyString
    }

    /// Property to display transaction date
    var transactionDate: String {
        return transactionDetailModel.trasactionDateLocalFormat ?? .emptyString
    }

    /// Property to display transaction amount
    var transactionAmount: String {
        return transactionDetailModel.amount
    }

    /// Property to get Credit or Debit text
    var creditOrDebitText: String {
        if transactionDetailModel.isDebited == true {
            return "transactions.debit".localized()
        } else {
            return "transaction.credit".localized()
        }
    }

    /// Transaction detail string array grid format
    var transactionDetailGridArray: [String] {
        var transactionDetailGridArray: [String] = []
        let gstAndNetAmount = retreiveGstFromBaseAmount()
        transactionDetailGridArray.append("transaction.id".localized())
        transactionDetailGridArray.append("\(id)")
        transactionDetailGridArray.append("transaction.summary".localized())
        transactionDetailGridArray.append(summary)
        transactionDetailGridArray.append("transaction.netAmount".localized())
        transactionDetailGridArray.append(gstAndNetAmount.netAmount)
        transactionDetailGridArray.append("transaction.gst".localized())
        transactionDetailGridArray.append(gstAndNetAmount.gst)
        transactionDetailGridArray.append("transaction.totalAmount".localized())
        transactionDetailGridArray.append(transactionAmount)
        return transactionDetailGridArray
    }
}

/// Extension for AccountTransactionDetailsViewModel
extension AccountTransactionDetailsViewModel {

    /// This function retreives gst from base amount and returns net amount and gst
    /// - Returns: Net amount and Gst
    final func retreiveGstFromBaseAmount() -> (netAmount: String, gst: String) {
        var transactionTotalAmount: Double = transactionDetailModel.credit ?? .zero
        if transactionDetailModel.isDebited == true, let debitAmount = transactionDetailModel.debit {
            transactionTotalAmount = debitAmount
        }
        // 0.15 being the 15% of gst on total amount
        let transactionNetAmount: Double = transactionTotalAmount - (transactionTotalAmount * 0.15)
        return (String(format: "%.2f", transactionNetAmount), String(format: "%.2f", (transactionTotalAmount * 0.15)))
    }
}
