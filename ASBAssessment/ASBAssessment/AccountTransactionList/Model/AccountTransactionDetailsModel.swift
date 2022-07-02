//
//  AccountTransactionDetailsModel.swift
//  ASBInterviewExercise
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Foundation

/// AccountTransactionDetailsModel to store account related information
struct AccountTransactionDetailsModel: Codable {

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
                return "\(debitAmount.delimiter)"
            } else if let creditAmount = credit {
                return "\(creditAmount.delimiter)"
            }
        }
        return ""
    }

    /// Transaction Date EEE, d MMM yyyy HH:mm format
    var trasactionDateLocalFormat: String? {
        guard let trascationDate = transactionDate, let localDate = Date().dateFromString(trascationDate, currentFormat: "yyyy-MM-dd'T'HH:mm:ss", expectedFormat: "EEE, d MMM yyyy HH:mm") else {
            return nil
        }
        return localDate
    }
}
