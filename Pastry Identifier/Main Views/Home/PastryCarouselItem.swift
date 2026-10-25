//
//  PastryCarouselItem.swift
//  Pastry Identifier
//

import SwiftUI

// Round pastry photo with its name underneath
struct PastryCarouselItem: View {
    let pastry: Pastry

    var body: some View {
        VStack {
            Image(pastry.name)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(.circle)
                .overlay(Circle().stroke(.pastryGradient, lineWidth: 3))
            Text(pastry.name)
                .font(.subheadline)
        }
    }
}

#Preview {
    PastryCarouselItem(pastry: pastries[0])
}
