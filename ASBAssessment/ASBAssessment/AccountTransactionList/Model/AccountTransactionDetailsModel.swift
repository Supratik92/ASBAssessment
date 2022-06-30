//
//  AccountTransactionDetailsModel.swift
//  ASBInterviewExercise
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Foundation

/// AccountDetailsModel to store account related information
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
