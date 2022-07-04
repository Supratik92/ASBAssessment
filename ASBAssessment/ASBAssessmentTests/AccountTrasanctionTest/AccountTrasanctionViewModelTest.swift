//
//  AccountTrasanctionViewModelTest.swift
//  ASBAssessmentTests
//
//  Created by Banerjee, Supratik on 02/07/22.
//

import XCTest
@testable import ASBAssessment

class AccountTrasanctionViewModelTest: XCTestCase {

    var accountTransactionMockService: AccountDetailsMockService?

    override func setUpWithError() throws {
        accountTransactionMockService = AccountDetailsMockService()
    }

    override func tearDownWithError() throws {
        accountTransactionMockService = nil
    }

    func setupAccountTransactionModel() async -> [AccountTransactionDetailsModel] {
        let accountResponse = await accountTransactionMockService?.getAccountDetailsInfo()
        switch accountResponse {
        case .success(let accountResponseModel):
            return accountResponseModel
        default:
            XCTFail("Unable to retrive results")
            return []
        }
    }

    /// Test method to verify sorting
    func testForAccountTransactionModelSorted() async {
        let accountResponseModel = await setupAccountTransactionModel()
        XCTAssert(accountResponseModel.isEmpty == false)
        let accountTrasactionListViewModel = AccountTransactionDetailsListViewModel(transactionDetailsArray: accountResponseModel)
        let transaction = accountTrasactionListViewModel.accountTransactionModel(for: .zero)
        XCTAssert(transaction?.amount == "+5,846.72")
        XCTAssert(transaction?.id == 861)
        XCTAssert(transaction?.summary == "Collier Group")
        XCTAssert(transaction?.isDebited == false)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
