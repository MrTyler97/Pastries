//
//  SheetTitleRow.swift
//  Pastry Identifier
//

import SwiftUI

// Pastry name with optional confidence badge
struct SheetTitleRow: View {
    let name: String
    let note: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(name)
                .font(.title)
                .bold()
            Spacer()
            // Catalog entries have no note
            if !note.isEmpty {
                Text(note)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.thinMaterial, in: .capsule)
            }
        }
    }
}

#Preview {
    SheetTitleRow(name: "Croissant", note: "High Confidence")
        .padding()
}
