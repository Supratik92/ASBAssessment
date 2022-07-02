//
//  ASBAssessmentTests.swift
//  ASBAssessmentTests
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import XCTest
@testable import ASBAssessment

class AccountTrasanctionModelTest: XCTestCase {

    var accountTransactionMockService: AccountDetailsMockService?
    var accountTransactionModelArray: [AccountTransactionDetailsModel]?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        accountTransactionMockService = AccountDetailsMockService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        accountTransactionMockService = nil
    }

    func setupAccountTransactionModel() async {
        let accountResponse = await accountTransactionMockService?.getAccountDetailsInfo()
        do {
            switch accountResponse {
            case .success(let accountResponseModel):
                accountTransactionModelArray = accountResponseModel
            case .failure:
                XCTFail("Received Error Response")
            case .none:
                XCTFail("Received Error Response")
            }
        }
    }

    func testAccountTransactionModelCount() async {
        await setupAccountTransactionModel()
        XCTAssertNotNil(accountTransactionModelArray)
        XCTAssert(accountTransactionModelArray?.count == 1000)
    }

    func testAccountTransactionModelValue() async {
        await setupAccountTransactionModel()

        if let accountTransactionModelArray = self.accountTransactionModelArray {
            for transaction in accountTransactionModelArray {
                XCTAssertNotNil(transaction.id)
                XCTAssertNotNil(transaction.transactionDate)
                XCTAssertNotNil(transaction.debit)
                XCTAssertNotNil(transaction.credit)
                XCTAssertNotNil(transaction.summary)
            }
        }
    }

    func testAccountTransactionDebitStatus() async {
        await setupAccountTransactionModel()
        if let accountTransactionModelArray = self.accountTransactionModelArray {
            for transaction in accountTransactionModelArray {
                if let debit = transaction.debit, debit > .zero {
                    XCTAssert(transaction.isDebited == true)
                }
            }
        }
    }

    func testAccountTransactionCreditStatus() async {
        await setupAccountTransactionModel()
        if let accountTransactionModelArray = self.accountTransactionModelArray {
            for transaction in accountTransactionModelArray {
                if let credit = transaction.credit, credit  > .zero {
                    XCTAssert(transaction.isDebited == false, "\(String(describing: transaction.id)) failed")
                }
            }
        }
    }

    func testAccountTransactionDate() async {
        await setupAccountTransactionModel()
        if let accountTransactionModelArray = self.accountTransactionModelArray {
            for transaction in accountTransactionModelArray {
                print(transaction.trasactionDateLocalFormat)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
