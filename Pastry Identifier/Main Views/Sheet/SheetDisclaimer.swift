//
//  SheetDisclaimer.swift
//  Pastry Identifier
//

import SwiftUI

// Always-visible model accuracy note
struct SheetDisclaimer: View {
    var body: some View {
        Label("This model may produce inaccurate results. Please verify findings independently.", systemImage: "info.circle")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    SheetDisclaimer()
        .padding()
}
