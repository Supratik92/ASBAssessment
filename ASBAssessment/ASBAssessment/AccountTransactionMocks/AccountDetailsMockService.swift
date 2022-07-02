//
//  AccountDetailsMockService.swift
//  AccountDetailsMockService
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Foundation

final class AccountDetailsMockService: AccountDetailsMockable, AccountDetailsServiceable {
    func getAccountDetailsInfo() async -> Result<[AccountTransactionDetailsModel], AccountDetailsReponseErrors> {
        // Here we are returning the json file instead of actual response from service.
        // Using this method for execution of test case
        return .success(loadJSON(filename: "AccountTransaction", type: [AccountTransactionDetailsModel].self))
    }
}
