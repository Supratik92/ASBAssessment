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


    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
