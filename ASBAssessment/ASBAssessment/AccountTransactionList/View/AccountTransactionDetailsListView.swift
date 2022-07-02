//
//  AccountTransactionDetailsListView.swift
//  ASBAssessment
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import SwiftUI

struct AccountTransactionDetailsListView: View {

    // MARK: - Constants
    private struct AccountTransactionDetailsListViewConstants {
        static let transactionReflectionTimeToAccount = "72"
        static let dividerHeight: CGFloat = 1
        static let arrowImageWidth: CGFloat = 8.35
        static let notransactionFoundLineHeight: CGFloat = 17
        static let numberOfPagesTrailingPadding: CGFloat = 17.25
        static let chevronWidth: CGFloat = 6.26
        static let chevronHeight: CGFloat = 16
        static let transactionStatusRowViewCornerRadius: CGFloat = 3
        static let transactionSummaryWidth: CGFloat = 248
        static let oneCount = 1
        static let chevronLeftRotation: Double = 180
        static let transactionHeaderTitleId = "transactionHeaderTitleId"
        static let debitBackgroundColor = Color.red.opacity(0.6)
        static let creditBackgroundColor = Color.green.opacity(0.6)
    }

    // MARK: - Properties
    @StateObject private var viewModel = AccountTransactionDetailsListViewModel()

    /// Property to show Network Error
    @State private var showError: Bool = false

    /// Property to show error description
    @State private var errorDescription: String = ""


    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.transactionDetailsArrayCount == .zero {
                    if !viewModel.isScreenLoading {
                        noTransactionFoundView
                    }
                } else {
                    ScrollView {
                        transactionLineItemView()
                    }
                }
                if viewModel.isScreenLoading {
                    ProgressView("transactions.loading".localized())
                }
            }.navigationTitle(Text("transaction.accountStatement".localized()))
                .navigationViewStyle(.automatic)
                .navigationBarTitleDisplayMode(.automatic)
                .onAppear {
                    loadTransactionList()
                }
        }.alert(isPresented: $showError) {
            Alert(title: Text("transaction.errorText".localized()),
                  message: Text(errorDescription),
                  dismissButton: .default(Text("transaction.okay")))
        }
    }
}

/// Extension for AccountTransactionDetailsListView related views
extension AccountTransactionDetailsListView {
    /// This method setup Transaction line item view
    /// - Returns: View
    @ViewBuilder private func transactionLineItemView() -> some View {
        VStack(alignment: .center, spacing: AccountDetailsConstants.LayoutConstants.marginThirtyTwo) {
            VStack(alignment: .leading, spacing: AccountDetailsConstants.LayoutConstants.marginEight) {
                ForEach(.zero..<viewModel.transactionDetailsArrayCount, id: \.self) { index in
                    if let transaction = viewModel.accountTransactionModel(for: index) {
                        transactionStatusView(for: transaction)
                    }
                }
            }.padding([.leading, .trailing], AccountDetailsConstants.LayoutConstants.defaultMargin)
        }.padding(.top, AccountDetailsConstants.LayoutConstants.marginTwentyFour)
    }

    /// This method setup Transaction Row View
    /// - Parameter info: AccountTransactionDetailsModel
    /// - Returns: View
    private func transactionStatusView(for info: AccountTransactionDetailsModel) -> some View {
        VStack(alignment: .leading, spacing: AccountDetailsConstants.LayoutConstants.marginThirtyTwo) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: .zero) {
                    transactionActivityTextView(text: info.summary, font: .helveticaTweleveBold)
                        .frame(width: AccountTransactionDetailsListViewConstants.transactionSummaryWidth)
                    transactionActivityTextView(text: info.trasactionDateLocalFormat, font: .helveticaFourteen)
                }
                Spacer()
                transactionActivityTextView(text: info.amount, font: .helveticaTweleveBold)
            }.padding()
        }.background(info.isDebited != nil ? (info.isDebited == true ? AccountTransactionDetailsListViewConstants.debitBackgroundColor : AccountTransactionDetailsListViewConstants.creditBackgroundColor) : Color.white)
            .cornerRadius(AccountTransactionDetailsListViewConstants.transactionStatusRowViewCornerRadius)
    }

    /// This method creates a text view for transaction
    /// - Parameters:
    ///   - text: The text
    ///   - font: font of text
    /// - Returns: View
    @ViewBuilder private func transactionActivityTextView(text: String?, font: Font) -> some View {
        if let text = text, !text.isEmpty {
            Text(text.localized())
                .foregroundColor(.black)
                .font(font)
                .frame(alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    /// No transaction found View
    private var noTransactionFoundView: some View {
        VStack(alignment: .center, spacing: AccountDetailsConstants.LayoutConstants.defaultMargin) {

            transactionActivityTextView(text: "transaction.noRecordsFound", font: .helveticaSixteen)

            transactionActivityTextView(text: "transaction.otherDates", font: .helveticaFourteen)
                .multilineTextAlignment(.center)

        }.padding(.top, AccountDetailsConstants.LayoutConstants.marginSixtyFour)
            .padding([.leading, .trailing], AccountDetailsConstants.LayoutConstants.marginTwentyFour)
    }
}

/// Extension for AccountTransactionDetailsListView related loading methods
extension AccountTransactionDetailsListView {

    /// Function to load transactions statements
    private func loadTransactionList() {
        Task.init {
            do {
                try await viewModel.retreiveAccountTransactionDetails()
            } catch let error {
                errorDescription = error.localizedDescription
            }
        }
    }
}

struct AccountTransactionDetailsListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTransactionDetailsListView()
    }
}
