//
//  AccountTransactionDetailsTests.swift
//  ASBAssessmentTests
//
//  Created by Banerjee, Supratik on 03/07/22.
//

import XCTest
@testable import ASBAssessment

class AccountTransactionDetailsTests: XCTestCase {

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

    func testRetreiveGstFromBaseAmount() async {
        let responseModel = await setupAccountTransactionModel()
        let accountTransactionViewModel = AccountTransactionDetailsViewModel(transactionDetailModel: responseModel[.zero])
        let gstAndNetAmount = accountTransactionViewModel.retreiveGstFromBaseAmount()
        XCTAssert(gstAndNetAmount.gst == "1406.93")
        XCTAssert(gstAndNetAmount.netAmount == "7972.62")
    }

    func testtransactionDetailGridArray() async {
        let responseModel = await setupAccountTransactionModel()
        let accountTransactionViewModel = AccountTransactionDetailsViewModel(transactionDetailModel: responseModel[.zero])
        XCTAssert(accountTransactionViewModel.transactionDetailGridArray.count == 12)
        XCTAssert(accountTransactionViewModel.transactionDetailGridArray.first == "transaction.id".localized())
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
