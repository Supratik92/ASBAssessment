//
//  String+Extensions.swift
//  CarDetails
//
//  Created by Banerjee, Supratik on 30/06/22.
//

import Foundation

extension String {

     /// Localization method to read localized key from bundle
    func localized() -> String {
        return localized(tableName: nil, bundle: Bundle.main)
    }

    func localized(tableName: String?, bundle: Bundle?) -> String {
        let bundle: Bundle = bundle ?? Bundle.main
        return bundle.localizedString(forKey: self, value: nil, table: tableName)
    }
}
