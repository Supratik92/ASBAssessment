//
//  Array+Extensions.swift
//  ASBAssessment
//
//  Created by Banerjee, Supratik on 02/07/22.
//

import Foundation

/// Allows to safely access an array element by index
/// Usage: array[safe: 2]
extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
