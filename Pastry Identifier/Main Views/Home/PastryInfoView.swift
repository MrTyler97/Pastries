//
//  PastryInfoView.swift
//  Pastry Identifier
//

import SwiftUI

// Information section
struct PastryInfoView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to Pastries")
                .font(.largeTitle)
                .bold()
                .padding()
            Spacer()
            Text("Model can only detect 5 different pastries.")
                .padding()
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .background(.regularMaterial)
                .cornerRadius(16)
            Text("More coming soon")
                .font(.caption)
                .padding(.bottom)
            VStack(alignment: .center) {
                ForEach(pastries){ pastry in
                    Text("\(pastry.name)")
                        .bold()
                        .padding(2)
                }
            }
            .padding()
            .multilineTextAlignment(.center)
            .frame(width: 300)
            .background(.regularMaterial)
            .cornerRadius(16)
            Spacer()
        }
    }
}

#Preview {
    PastryInfoView()
}
