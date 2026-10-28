//
//  AllergenView.swift
//  Pastry Identifier
//
//  Allergen and dietary chips for a classified pastry.
//

import SwiftUI

struct AllergenView: View {
    // Classification name, e.g. "Croissant"
    let classLabel: String

    @State private var food: PastryFood?
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 10) {
            Text("Allergens")
                .foregroundColor(.primary)
                .font(.headline)

            if let food = food {
                content(for: food)
                FatSecretAttribution()
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
                print("Allergen error: \(error)")
                errorMessage = error.message
            } catch {
                // Network failure, e.g. proxy not running
                print("Allergen error: \(error)")
                errorMessage = "Couldn't reach nutrition server"
            }
        }
    }

    // Red chips for allergens, green for diets it fits, then a safety note
    @ViewBuilder
    func content(for food: PastryFood) -> some View {
        // Missing or empty list is unknown, never "allergen free"
        if let allergens = food.allergens, !allergens.isEmpty {
            let contained = allergens.trueNames()
            if contained.isEmpty {
                Text("None listed")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            } else {
                chips(contained, tint: .red)
            }
        } else {
            Text("No allergen data available")
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
            Text("Dietary")
            .font(.headline)
        let diets = food.dietaryPreferences?.trueNames() ?? []
        if !diets.isEmpty {
            chips(diets, tint: .green)
        }

        // Unknowns aren't shown as chips, so call them out
        Text(food.allergens?.hasUnknown == true
             ? "Some allergens unknown, check with the bakery"
             : "Always check with the bakery")
            .foregroundColor(.secondary)
            .font(.footnote)
    }

    // One row of capsule tags; scrolls if it runs past the popover
    func chips(_ names: [String], tint: Color) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(names, id: \.self) { name in
                    Text(name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(tint)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(tint.opacity(0.15), in: Capsule())
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    AllergenView(classLabel: "Croissant")
}
