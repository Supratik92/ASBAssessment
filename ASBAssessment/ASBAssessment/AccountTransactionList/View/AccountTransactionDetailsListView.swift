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
        static let notransactionFoundLineHeight: CGFloat = 17
        static let chevronWidth: CGFloat = 20
        static let chevronHeight: CGFloat = 20
        static let transactionStatusRowViewCornerRadius: CGFloat = 3
        static let transactionSummaryWidth: CGFloat = 248
        static let transactionHeaderTitleId = "transactionHeaderTitleId"
        static let debitBackgroundColor = Color.red.opacity(0.6)
        static let creditBackgroundColor = Color.green.opacity(0.6)
        static let transactionStatusViewImageDimensions: CGFloat = 40
        static let textColorOpacity: CGFloat = 0.8
        static let accessibilityPriorityFirst: Double = 2
        static let accessibilityPrioritySecond: Double = 1
        static let accessibilityPriorityThird: Double = 0
    }

    // MARK: - Properties
    @StateObject private var viewModel = AccountTransactionDetailsListViewModel()

    /// Property to show Network Error
    @State private var showError: Bool = false

    /// Property to show error description
    @State private var errorDescription: String = .emptyString


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
                .onFirstAppear {
                    loadTransactionList()
                }
        }.alert(isPresented: $showError) {
            Alert(title: Text("transaction.errorText".localized()),
                  message: Text(errorDescription),
                  dismissButton: .default(Text("transaction.okay")))
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
                        NavigationLink {
                            AccountTransactionDetailsView(viewModel: AccountTransactionDetailsViewModel(transactionDetailModel: transaction))
                        } label: {
                            transactionStatusView(for: transaction)
                        }.accessibilityElement(children: .contain)
                            .accessibilityRemoveTraits(.isButton)
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
            HStack(alignment: .center) {
                // credit image
                Image(systemName: AccountDetailsConstants.ImageName.card)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: AccountTransactionDetailsListViewConstants.transactionStatusViewImageDimensions, height: AccountTransactionDetailsListViewConstants.transactionStatusViewImageDimensions)
                    .accessibilityHidden(true)

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: AccountDetailsConstants.LayoutConstants.defaultMargin) {
                        transactionActivityTextView(text: info.summary, font: .helveticaFourteenBold)
                            .accessibilityLabel(Text(accessibilitySummaryLabel(text: info.summary)))
                            .accessibilitySortPriority(AccountTransactionDetailsListViewConstants.accessibilityPriorityFirst)

                        transactionActivityTextView(text: info.trasactionDateLocalFormat, font: .helveticaFourteen)
                            .accessibilityLabel(Text(accessibilityDateLabel(text: info.trasactionDateLocalFormat)))
                            .accessibilitySortPriority(AccountTransactionDetailsListViewConstants.accessibilityPrioritySecond)
                    }
                    Spacer()

                    VStack(alignment: .trailing) {
                        transactionActivityTextView(text: info.amount, font: .helveticaTweleveBold)
                            .accessibilityLabel(Text(accessibilityAmountLabel(text: info.amount)))
                            .accessibilityHint(Text(accessibilityAmountHint(isDebit: info.isDebited)))
                            .accessibilitySortPriority(AccountTransactionDetailsListViewConstants.accessibilityPriorityThird)
                        Spacer()
                        Image(systemName: AccountDetailsConstants.ImageName.chevron)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: AccountTransactionDetailsListViewConstants.chevronWidth, height: AccountTransactionDetailsListViewConstants.chevronHeight)
                    }
                }.padding()
            }.padding(.leading, AccountDetailsConstants.LayoutConstants.defaultMargin)
        }.background(info.isDebited != nil ? (info.isDebited == true ? AccountTransactionDetailsListViewConstants.debitBackgroundColor : AccountTransactionDetailsListViewConstants.creditBackgroundColor) : Color.white)
            .cornerRadius(AccountTransactionDetailsListViewConstants.transactionStatusRowViewCornerRadius)
            .accessibilityElement(children: .contain)
    }

    /// This method creates a text view for transaction
    /// - Parameters:
    ///   - text: The text
    ///   - font: font of text
    /// - Returns: View
    @ViewBuilder private func transactionActivityTextView(text: String?, font: Font) -> some View {
        if let text = text, !text.isEmpty {
            Text(text.localized())
                .foregroundColor(.black.opacity(AccountTransactionDetailsListViewConstants.textColorOpacity))
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

    /// Accessibility Summary Label
    /// - Parameter text: accessibility text
    /// - Returns: Provides Accessibility Summary Label
    private func accessibilitySummaryLabel(text: String?) -> String {
        let accessibilitySummary = "accessibilityLabel.summary".localized() + (text ?? .emptyString)
        return accessibilitySummary
    }

    /// Accessibility Date Label
    /// - Parameter text: accessibility text
    /// - Returns: Provides Accessibility Date Label
    private func accessibilityDateLabel(text: String?) -> String {
        let accessibilitySummary = "accessibilityLabel.date".localized() + (text ?? .emptyString)
        return accessibilitySummary
    }

    /// Accessibility Amount Label
    /// - Parameter text: accessibility text
    /// - Returns: Provides Accessibility Amount Label
    private func accessibilityAmountLabel(text: String?) -> String {
        return "accessibilityLabel.amount".localized() + (text ?? .emptyString)
    }

    /// Accessibility Amount Hint
    /// - Parameter isDebit: Is Debited transaction
    /// - Returns: Provides Accessibility Amount Hint
    private func accessibilityAmountHint(isDebit: Bool?) -> String {
        let creditOrDebit: String = isDebit != nil ? (isDebit == true ? "transactions.debit".localized() : "transaction.credit".localized()) : .emptyString
        return creditOrDebit
    }

}
