//
//  SheetComponent.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/6/25.
//

import SwiftUI

// Result and catalog sheet
struct SheetComponent: View {
    let imageName: String
    let note: String
    let pastry: Pastry?

    var body: some View {
        if let pastry = pastry {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SheetHeroImage(imageName: imageName)
                    SheetTitleRow(name: imageName, note: note)
                    SheetActionBar(pastry: pastry, classLabel: imageName)
                    SheetInfoCard(title: "Origin", symbol: "globe", text: pastry.origin)
                    SheetInfoCard(title: "About", symbol: "book", text: pastry.description)
                    SheetDisclaimer()
                }
                .padding()
            }
        } else {
            // Unknown or out-of-scope result
            VStack {
                ContentUnavailableView(imageName, systemImage: "questionmark.circle", description: Text(note))
                SheetDisclaimer()
                    .padding()
            }
        }
    }
}

#Preview("Pastry") {
    SheetComponent(imageName: "Cookie", note: "High Confidence", pastry: pastries[0])
}

#Preview("Unknown") {
    SheetComponent(imageName: "Unclassified", note: "Very Low Confidence - try different angle", pastry: nil)
}
