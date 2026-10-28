//
//  FoodAttribute.swift
//  Pastry Identifier
//
//  Picks which allergen and diet flags to show.
//

import Foundation

extension Array where Element == FoodAttribute {
    // Names flagged true, alphabetical; matched by value, never by position
    func trueNames() -> [String] {
        filter { $0.value == true }
            .map(\.name)
            .sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
    }

    // Any flag FatSecret couldn't confirm either way
    var hasUnknown: Bool {
        contains { $0.value == nil }
    }
}
