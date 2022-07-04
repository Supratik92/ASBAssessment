//
//  Date+Extensions.swift
//  ASBAssessment
//
//  Created by Banerjee, Supratik on 01/07/22.
//

import Foundation

extension Date {

    static let dateFormatter = DateFormatter()

    /// This method formats string date to another expected date format
    /// - Parameters:
    ///   - dateString: Date in String
    ///   - currentFormat: current format in string
    ///   - expectedFormat: expected formate in string
    /// - Returns: date in expected format
    func dateFromString(_ dateString: String, currentFormat: String, expectedFormat: String) -> String? {
        let dateFormatter = Date.dateFormatter
        let tempLocale = dateFormatter.locale  // save locale temporarily
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat =  currentFormat
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = expectedFormat
        dateFormatter.locale = tempLocale // reset the locale

        guard let unwrappedDate = date else {
            return nil
        }
        return dateFormatter.string(from: unwrappedDate)
    }

    /// This method formats string date to another expected date
    /// - Parameters:
    ///   - dateString: String Date
    ///   - format: String Date Format
    /// - Returns: Date
    func dateFromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = Date.dateFormatter
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat =  format
        return dateFormatter.date(from: dateString)
    }

}
