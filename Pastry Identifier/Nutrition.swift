//
//  Nutrition.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/9/25.
//
import SwiftUI

struct Nutrition{
    var Fat: String
    var Carbohydrates: String
    var Sugar: String
    var Fiber: String
    var Cholesterol: String
    var Protein: String
    var Sodium: String
    var Total_Calories: String
}

let nutritionExample: Nutrition = Nutrition(Fat: "1g", Carbohydrates: "2g", Sugar: "3g", Fiber: "4g", Cholesterol: "5g", Protein: "6g", Sodium: "7g", Total_Calories: "8g")

struct NutritionRowView: View {
    var nutrition: Nutrition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Nutritional Information")
                .foregroundColor(.primary)
                .font(.headline)
            
            HStack(spacing: 3) {
                Label(nutrition.Total_Calories, systemImage: "flame.fill")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Label(nutrition.Protein, systemImage: "bolt.fill")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Label(nutrition.Carbohydrates, systemImage: "leaf.fill")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Label(nutrition.Fat, systemImage: "drop.fill")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Label(nutrition.Sugar, systemImage: "cube.fill")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Label(nutrition.Fiber, systemImage: "circle.grid.cross.fill")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Label(nutrition.Cholesterol, systemImage: "heart.fill")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Label(nutrition.Sodium, systemImage: "sparkles")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
}

struct NutritionList: View {
    var nutritionItems: [Nutrition]
    
    var body: some View {
        List {
            ForEach(nutritionItems.indices, id: \.self) { index in
                NutritionRowView(nutrition: nutritionItems[index])
            }
        }
    }
}
