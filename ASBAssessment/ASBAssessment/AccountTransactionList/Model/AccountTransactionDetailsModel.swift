//
//  AccountTransactionDetailsModel.swift
//  ASBInterviewExercise
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Foundation

/// AccountTransactionDetailsModel to store account related information
struct AccountTransactionDetailsModel: Codable {

    /// Date format to show in view
    private static let viewDateFormat = "EEE, d MMM yyyy HH:mm"

    /// Date format of transaction date
    static let transactionDateFormat = "yyyy-MM-dd'T'HH:mm:ss"

    /// Property represents Id of account
    let id: Int?

    /// Property represents tracsaction Dates
    let transactionDate: String?

    /// Property represents summary of account
    let summary: String?

    /// Property represents debit amount
    let debit: Double?

    /// Property represents credit amount
    let credit: Double?
}

/// Extension of AccountTransactionDetailsModel for compuations
extension AccountTransactionDetailsModel {

    /// Property to determine if transaction is a debit one
    var isDebited: Bool? {
        guard let debit = debit else {
            return nil
        }
        return debit > .zero
    }

    /// Property provides you  transaction amount in string
    var amount: String {
        if let isDebited = isDebited {
            if isDebited, let debitAmount = debit {
                return "-\(debitAmount.delimiter)"
            } else if let creditAmount = credit {
                return "+\(creditAmount.delimiter)"
            }
        }
        return .emptyString
    }

    /// Transaction Date EEE, d MMM yyyy HH:mm format
    var trasactionDateLocalFormat: String? {
        guard let trascationDate = transactionDate, let localDate = Date().dateFromString(trascationDate, currentFormat: AccountTransactionDetailsModel.transactionDateFormat, expectedFormat: AccountTransactionDetailsModel.viewDateFormat) else {
            return nil
        }
        return localDate
    }
}
