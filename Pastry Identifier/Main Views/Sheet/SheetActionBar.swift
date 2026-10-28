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
    // One proxy call per sheet, shared by both popovers
    @State private var food: PastryFood?
    @State private var errorMessage: String?

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
                AllergenView(food: $food, errorMessage: $errorMessage)
                    .presentationCompactAdaptation(.popover)
                    .padding()
            }

            SheetActionButton(title: "Nutrition", symbol: "list.bullet.rectangle", tint: .green) {
                showNutrition.toggle()
            }
            .popover(isPresented: $showNutrition) {
                NutritionRowView(food: $food, errorMessage: $errorMessage)
                    .presentationCompactAdaptation(.popover)
                    .padding()
            }
        }
        // Starts when the sheet appears, so data is usually ready before a tap
        .task { await load() }
    }

    // Fetch food data once; popovers show a spinner until it lands
    func load() async {
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

#Preview {
    SheetActionBar(pastry: pastries[0], classLabel: pastries[0].name)
        .padding()
}
