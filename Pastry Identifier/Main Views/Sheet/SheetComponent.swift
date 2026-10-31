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
    // User's photo; nil for catalog sheets
    var capturedImage: UIImage? = nil

    var body: some View {
        if let pastry = pastry {
            if let capturedImage {
                // Photo result: full-width header, padded content below
                ScrollView {
                    VStack(spacing: 20) {
                        SheetPhotoHeader(imageName: imageName, capturedImage: capturedImage, note: note)
                        VStack(alignment: .leading, spacing: 20) {
                            details(for: pastry)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
                .ignoresSafeArea(edges: .top)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SheetHeroImage(imageName: imageName)
                        SheetTitleRow(name: imageName, note: note)
                        details(for: pastry)
                    }
                    .padding()
                }
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

    // Shared body under either header
    @ViewBuilder
    private func details(for pastry: Pastry) -> some View {
        SheetActionBar(pastry: pastry, classLabel: imageName)
        SheetInfoCard(title: "Origin", symbol: "globe", text: pastry.origin)
        SheetInfoCard(title: "About", symbol: "book", text: pastry.description)
        SheetDisclaimer()
    }
}

#Preview("Pastry") {
    SheetComponent(imageName: "Cookie", note: "High Confidence", pastry: pastries[0])
}

#Preview("Photo") {
    SheetComponent(imageName: "Cookie", note: "High Confidence", pastry: pastries[0], capturedImage: UIImage(named: "Croissant"))
}

#Preview("Unknown") {
    SheetComponent(imageName: "Unclassified", note: "Very Low Confidence - try different angle", pastry: nil)
}
