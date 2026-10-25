//
//  IdentifyHeroCard.swift
//  Pastry Identifier
//

import SwiftUI

// Call to action for identifying
struct IdentifyHeroCard: View {
    let onTakePhoto: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "sparkle.magnifyingglass")
                .font(.largeTitle)
            Text("What pastry is this?")
                .font(.title2)
                .bold()
            Text("Snap or choose a photo and we'll identify it.")
                .font(.subheadline)
                .opacity(0.9)
            Button(action: onTakePhoto){
                Label("Take Photo", systemImage: "camera.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glass)
            .controlSize(.large)
            .padding(.top, 4)
        }
        .foregroundStyle(.white)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.pastryGradient, in: .rect(cornerRadius: 28))
        .padding(.horizontal)
    }
}

#Preview {
    IdentifyHeroCard(onTakePhoto: {})
}
