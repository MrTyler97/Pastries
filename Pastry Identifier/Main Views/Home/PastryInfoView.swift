//
//  PastryInfoView.swift
//  Pastry Identifier
//

import SwiftUI

// Information sheet
struct PastryInfoView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    VStack(alignment: .leading, spacing: 18) {
                        Text("How it works")
                            .font(.title3)
                            .bold()
                        InfoRow(
                            symbol: "camera.fill",
                            tint: .pastryBrown,
                            title: "Identify",
                            text: "Snap or choose a photo. The on-device model recognizes a small set of pastries, with more coming soon."
                        )
                        InfoRow(
                            symbol: "list.bullet.rectangle",
                            tint: .green,
                            title: "Nutrition",
                            text: "Tap the nutrition button on a result to see calories, macros, sugar and sodium for a typical serving, from fatsecret. Values are estimates and vary by bakery and recipe."
                        )
                        InfoRow(
                            symbol: "exclamationmark.bubble.fill",
                            tint: .red,
                            title: "Allergens",
                            text: "The allergen button lists common ingredients such as dairy, gluten, nuts and yeast. It is general guidance, not a guarantee. Always ask the bakery if you have an allergy."
                        )
                        InfoRow(
                            symbol: "location.magnifyingglass",
                            tint: .pastryAmber,
                            title: "Find bakeries",
                            text: "See nearby bakeries that may carry the pastry."
                        )
                        FatSecretAttribution()
                    }
                    noteCard
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    // Brand icon, title and subtitle
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image("Gradient-Icon-Map-Navigation-App-Logo")
                .resizable()
                .scaledToFit()
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .clipShape(.circle)
            Text("About Pastries")
                .font(.largeTitle)
                .bold()
            Text("Identify pastries from a photo and learn what's in them.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // Accuracy disclaimer
    private var noteCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Good to know", systemImage: "info.circle")
                .font(.headline)
            Text("Identification can be wrong. Double check results, especially before relying on nutrition or allergen info.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 20))
    }
}

// One feature line with a tinted icon
private struct InfoRow: View {
    let symbol: String
    let tint: Color
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(tint)
                .frame(width: 44, height: 44)
                .background(tint.opacity(0.15), in: .rect(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    PastryInfoView()
}
