//
//  FatSecretAttribution.swift
//  Pastry Identifier
//

import SwiftUI

// Required fatsecret attribution snippet
struct FatSecretAttribution: View {
    static let url = URL(string: "https://www.fatsecret.com")

    var body: some View {
        Group {
            if let url = Self.url {
                Link("Powered by fatsecret", destination: url)
            } else {
                Text("Powered by fatsecret")
            }
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    FatSecretAttribution()
}
