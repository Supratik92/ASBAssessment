//
//  Double+Extensions.swift
//  ASBAssessment
//
//  Created by Banerjee, Supratik on 02/07/22.
//

import Foundation

extension Double {

    /// Static instance of number formatter
    static let formatter = NumberFormatter()

    /// Instance of decimal number formatter
    private static var decimalNumberFormatter: NumberFormatter = {
        Double.formatter.numberStyle = .decimal
        return Double.formatter
    }()

    /// Delimiter
    var delimiter: String {
        return Double.decimalNumberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
