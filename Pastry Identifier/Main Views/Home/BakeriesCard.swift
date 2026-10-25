//
//  BakeriesCard.swift
//  Pastry Identifier
//

import MapKit
import SwiftUI

// Map preview that opens the Bakeries tab
struct BakeriesCard: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap){
            VStack(alignment: .leading, spacing: 0) {
                Map(initialPosition: .userLocation(fallback: .automatic)) {
                    UserAnnotation()
                }
                .frame(height: 160)
                .allowsHitTesting(false)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Bakeries near you")
                            .font(.headline)
                        Text("Find a bakery around you")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
                .padding()
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 24))
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

#Preview {
    BakeriesCard(onTap: {})
}
