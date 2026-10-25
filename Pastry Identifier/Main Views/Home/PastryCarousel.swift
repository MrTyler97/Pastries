//
//  PastryCarousel.swift
//  Pastry Identifier
//

import SwiftUI

// Horizontal list of pastries the model knows
struct PastryCarousel: View {
    let pastries: [Pastry]
    let onSelect: (Pastry) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pastries we know")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    ForEach(pastries) { pastry in
                        Button(action: {
                            onSelect(pastry)
                        }){
                            PastryCarouselItem(pastry: pastry)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    PastryCarousel(pastries: pastries, onSelect: { _ in })
}
