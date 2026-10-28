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

            SheetActionButton(title: "Sensitivities", symbol: "fork.knife.circle", tint: .orange) {
                showAllergens.toggle()
            }
            .popover(isPresented: $showAllergens) {
                AllergenView(classLabel: classLabel)
                    .presentationCompactAdaptation(.popover)
                    .padding()
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
