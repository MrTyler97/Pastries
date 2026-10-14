//
//  Objects.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/13/26.
//

// Mirrors PastryFood / PastryServing in the proxy
struct PastryFood: Decodable {
    let foodId: String
    let name: String
    let brand: String?          // Only on branded foods 
    let servings: [PastryServing]
}

struct PastryServing: Decodable {
    let servingId: String
    let description: String     // e.g. "1 medium"
    let grams: Double?
    let calories: Double
    let carbs: Double
    let protein: Double
    let fat: Double
    let saturatedFat: Double?
    let sugar: Double?
    let fiber: Double?
    let sodium: Double?         // mg
    let cholesterol: Double?    // mg
}
