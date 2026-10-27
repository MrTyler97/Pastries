//
//  SheetActionButton.swift
//  Pastry Identifier
//

import SwiftUI

// Labeled glass button with an icon on top
struct SheetActionButton: View {
    let title: String
    let symbol: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: symbol)
                    .font(.title3)
                    .foregroundStyle(tint)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SheetActionButton(title: "Nutrition", symbol: "list.bullet.rectangle", tint: .green, action: {})
        .padding()
}
