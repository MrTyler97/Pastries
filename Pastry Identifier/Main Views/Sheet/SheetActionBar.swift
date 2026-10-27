//
//  SheetActionBar.swift
//  Pastry Identifier
//

import SwiftUI

// Bakeries, allergens and nutrition actions
struct SheetActionBar: View {
    let pastry: Pastry
    // Classification label for the nutrition lookup
    let classLabel: String

    @State private var showMap = false
    @State private var showAllergens = false
    @State private var showNutrition = false

    var body: some View {
        HStack(spacing: 12) {
            SheetActionButton(title: "Bakeries", symbol: "location.magnifyingglass", tint: .primary) {
                showMap.toggle()
            }
            .fullScreenCover(isPresented: $showMap) {
                MapView(pastry: pastry)
            }

            SheetActionButton(title: "Allergens", symbol: "exclamationmark.bubble.fill", tint: .red) {
                showAllergens.toggle()
            }
            .popover(isPresented: $showAllergens) {
                VStack {
                    Text("May Contain")
                        .font(.headline)
                    HStack {
                        Text("Dairy")
                        Text("Gluten")
                        Text("Nuts")
                        Text("Yeast")
                    }
                    .padding()
                    FatSecretAttribution()
                }
                .padding()
                .presentationCompactAdaptation(.popover)
            }

            SheetActionButton(title: "Nutrition", symbol: "list.bullet.rectangle", tint: .green) {
                showNutrition.toggle()
            }
            .popover(isPresented: $showNutrition) {
                NutritionRowView(classLabel: classLabel)
                    .presentationCompactAdaptation(.popover)
                    .padding()
            }
        }
    }
}

#Preview {
    SheetActionBar(pastry: pastries[0], classLabel: pastries[0].name)
        .padding()
}
