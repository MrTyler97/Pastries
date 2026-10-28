//
//  Theme.swift
//  Pastry Identifier
//

import SwiftUI

// Brand colors
extension Color {
    static let pastryBrown = Color(red: 0.55, green: 0.33, blue: 0.16)
    static let pastryAmber = Color(red: 0.95, green: 0.62, blue: 0.18)
    static let pastryCoffee = Color(.secondary)
    static let pastryVanilla = Color(.accent)
}

// Brown to amber brand gradient for hero cards and main buttons
extension ShapeStyle where Self == LinearGradient {
    static var pastryGradient: LinearGradient {
        LinearGradient(colors: [.pastryVanilla, .pastryCoffee], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
