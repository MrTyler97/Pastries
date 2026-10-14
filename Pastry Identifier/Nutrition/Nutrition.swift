//
//  Nutrition.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/9/25.

import SwiftUI

struct NutritionRowView: View {
    // Classification name, e.g. "Croissant"
    let classLabel: String

    @State private var food: PastryFood?
    @State private var errorMessage: String?

    var body: some View {
        VStack() {
            Text("Nutrition")
                .foregroundColor(.primary)
                .font(.headline)

            if let food = food, let serving = food.servings.first {
                // Branded numbers aren't a generic estimate, so say whose they are
                if let brand = food.brand {
                    Text(brand)
                        .font(.caption)
                }
                // First serving is the sensible default ("1 medium")
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
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            } else {
                ProgressView()
            }
        }
        .frame(minWidth: 250)
        // Runs when the popover appears
        .task {
            do {
                food = try await NutritionService().food(forClassLabel: classLabel)
            } catch let error as NutritionError {
                print("Nutrition error: \(error)")
                errorMessage = error.message
            } catch {
                // Network failure, e.g. proxy not running
                print("Nutrition error: \(error)")
                errorMessage = "Couldn't reach nutrition server"
            }
        }
    }

    // One nutrient line. nil means FatSecret doesn't know it, which is not the same as 0
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

#Preview {
    NutritionRowView(classLabel: "Croissant")
}
