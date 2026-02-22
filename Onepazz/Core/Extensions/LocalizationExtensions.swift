//
//  LocalizationExtensions.swift
//  Onepazz
//
//  Created by Claude on 2/21/26.
//

import Foundation

extension String {
    /// Returns the localized string for the current key
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    /// Returns the localized string with format arguments
    func localized(_ arguments: CVarArg...) -> String {
        String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}
