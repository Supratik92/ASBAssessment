//
//  AccountTransactionDetailsView.swift
//  ASBAssessment
//
//  Created by Banerjee, Supratik on 04/07/22.
//

import SwiftUI

struct AccountTransactionDetailsView: View {

    // MARK: Constants & Properties

    private struct AccountTransactionDetailsViewConstants {
        static let debitBackgroundColor = Color.red.opacity(0.6)
        static let creditBackgroundColor = Color.green.opacity(0.6)
        static let cardImageWidth: CGFloat = 40
        static let cardImageHeight: CGFloat = 20
        static let shadowAndCornerRadius: CGFloat = 10
        static let textColorOpacity: CGFloat = 0.8
    }

    /// Property for AccountTransactionDetailsViewModel
    @ObservedObject var viewModel: AccountTransactionDetailsViewModel

    /// Grid layout constants
    private let shopHoursGrid = [GridItem(.flexible(minimum: .zero, maximum: .infinity), spacing: .zero),
                                 GridItem(.flexible(minimum: .zero, maximum: .infinity),
                                          spacing: .zero, alignment: .trailing)]

    var body: some View {
        ScrollView {
            VStack {
                topView
                detailGridView
            }.shadow(radius: AccountTransactionDetailsViewConstants.shadowAndCornerRadius)
                .background(Color.lightPurple)
                .cornerRadius(AccountTransactionDetailsViewConstants.shadowAndCornerRadius)
                .padding()
        }
    }
}

/// Extension of AccountTransactionDetailsView for supporting views
extension AccountTransactionDetailsView {

    /// Top view of transaction details
    private var topView: some View {
        VStack(alignment: .center) {
            Image(systemName: AccountDetailsConstants.ImageName.bank)
                .resizable()
                .scaledToFit()
                .frame(width: AccountTransactionDetailsViewConstants.cardImageWidth, height: AccountTransactionDetailsViewConstants.cardImageHeight)
                .foregroundColor(viewModel.isDebit ? AccountTransactionDetailsViewConstants.debitBackgroundColor : AccountTransactionDetailsViewConstants.creditBackgroundColor)

            HStack(alignment: .top, spacing: AccountDetailsConstants.LayoutConstants.marginEight) {
                transactionActivityTextView(text: "transaction.transactionType", font: .helveticaSixteenBold)
                transactionActivityTextView(text: viewModel.creditOrDebitText, font: .helveticaSixteen)
            }.padding()
        }.padding()
    }

    /// Transaction Grid View
    private var detailGridView: some View {
        LazyVGrid(columns: shopHoursGrid,
                  alignment: .leading,
                  spacing: AccountDetailsConstants.LayoutConstants.marginEight) {
            ForEach(.zero..<viewModel.transactionDetailGridArray.count, id: \.self) { index in
                if index % 2 == .zero {
                    transactionActivityTextView(text: viewModel.transactionDetailGridArray[index], font: .helveticaFourteenBold)
                } else {
                    transactionActivityTextView(text: viewModel.transactionDetailGridArray[index], font: .helveticaFourteen)
                }
            }
        }.padding()
    }

    /// This method creates a text view for transaction
    /// - Parameters:
    ///   - text: The text
    ///   - font: font of text
    /// - Returns: View
    @ViewBuilder private func transactionActivityTextView(text: String?, font: Font) -> some View {
        if let text = text, !text.isEmpty {
            Text(text.localized())
                .foregroundColor(.black.opacity(AccountTransactionDetailsViewConstants.textColorOpacity))
                .font(font)
                .frame(alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
