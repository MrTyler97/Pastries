//
//  SheetHeroImage.swift
//  Pastry Identifier
//

import SwiftUI

// Large rounded pastry photo
struct SheetHeroImage: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .clipShape(.rect(cornerRadius: 28))
            .shadow(color: .black.opacity(0.2), radius: 12, y: 6)
    }
}

#Preview {
    SheetHeroImage(imageName: "Croissant")
        .padding()
}
