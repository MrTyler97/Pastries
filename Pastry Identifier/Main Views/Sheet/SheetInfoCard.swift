//
//  SheetInfoCard.swift
//  Pastry Identifier
//

import SwiftUI

// Titled text card for origin and description
struct SheetInfoCard: View {
    let title: String
    let symbol: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: symbol)
                .font(.headline)
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 20))
    }
}

#Preview {
    SheetInfoCard(title: "Origin", symbol: "globe", text: pastries[0].origin)
        .padding()
}
