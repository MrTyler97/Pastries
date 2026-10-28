//
//  Nutrition.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/9/25.

import SwiftUI

struct NutritionRowView: View {
    // Bound to SheetActionBar's state so the popover updates when the load finishes
    @Binding var food: PastryFood?
    @Binding var errorMessage: String?

    var body: some View {
        VStack() {
            Text("Nutrition")
                .foregroundColor(.primary)
                .font(.headline)

            if let food = food, let serving = food.servings.first {
                // Show whose numbers these are
                if let brand = food.brand {
                    Text(brand)
                        .font(.caption)
                }
                // Default serving, e.g. "1 medium"
                Text(serving.description)
                    .font(.caption)
                    .padding(.bottom, 4)

                row("Calories", serving.calories, unit: "")
                row("Protein", serving.protein, unit: "g")
                row("Total Carbohydrates", serving.carbs, unit: "g")
                row("Fat", serving.fat, unit: "g")
                row("Sugar", serving.sugar, unit: "g")
                row("Fiber", serving.fiber, unit: "g")
                row("Cholesterol", serving.cholesterol, unit: "mg")
                row("Sodium", serving.sodium, unit: "mg")
                FatSecretAttribution()
                    .padding(.top, 6)
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            } else {
                ProgressView()
            }
        }
        .frame(minWidth: 250)
    }

    // One nutrient line; nil means unknown, not 0
    func row(_ name: String, _ value: Double?, unit: String) -> some View {
        HStack(spacing: 3) {
            Text(name)
            Spacer()
            if let value = value {
                Text("\(value, specifier: "%.1f")\(unit)")
            } else {
                Text("—")
            }
        }
        .foregroundColor(.secondary)
        .font(.subheadline)
    }
}

#Preview("Loaded") {
    NutritionRowView(food: .constant(.sample), errorMessage: .constant(nil))
        .padding()
}

#Preview("Loading") {
    NutritionRowView(food: .constant(nil), errorMessage: .constant(nil))
        .padding()
}
