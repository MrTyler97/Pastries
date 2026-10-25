//
//  PastryPin.swift
//  Pastry Identifier
//
//  Map pin showing the pastry photo for likely matches.
//

import SwiftUI

struct PastryPin: View {
    // Asset name, same as Pastry.name
    let imageName: String
    // Grows a little when tapped
    var isSelected = false

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color(.brown), lineWidth: 3))
            .shadow(radius: 4)
            .scaleEffect(isSelected ? 1.3 : 1)
            .animation(.spring(duration: 0.25), value: isSelected)
    }
}

#Preview {
    PastryPin(imageName: "Croissant")
}
