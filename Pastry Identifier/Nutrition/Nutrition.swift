//
//  Nutrition.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/9/25.



// Feature not functional at this moment.

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
    var nutrition: Nutrition = nutritionExample
    
    var body: some View {
        VStack() {
            Text("Nutrition")
                .foregroundColor(.primary)
                .font(.headline)
            
            HStack(spacing: 3) {
                Text("Calories")
                Spacer()
                Text(nutrition.Total_Calories)
                    
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Text("Protein")
                Spacer()
                Text(nutrition.Protein)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Text("Total Carbohydrates")
                Spacer()
                Text(nutrition.Carbohydrates)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Text("Fat")
                Spacer()
                Text(nutrition.Fat)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Text("Sugar")
                Spacer()
                Text(nutrition.Sugar)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Text("Fiber")
                Spacer()
                Text(nutrition.Fiber)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Text("Cholesterol")
                Spacer()
                Text(nutrition.Cholesterol)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            HStack(spacing: 3) {
                Text("Sodium")
                Spacer()
                Text(nutrition.Sodium)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
}

//struct NutritionList: View {
//    var nutritionItems: [Nutrition]
//    
//    var body: some View {
//        List {
//            ForEach(nutritionItems.indices, id: \.self) { index in
//                NutritionRowView(nutrition: nutritionItems[index])
//            }
//        }
//    }
//}
