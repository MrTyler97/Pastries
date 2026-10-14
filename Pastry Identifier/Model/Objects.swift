//
//  Objects.swift
//  Pastry Identifier
//
//  Created by Vic  on 10/13/26.
//
import MapKit
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

// A search result shown on the map
struct Bakery: Identifiable, Hashable {
    let id = UUID()
    let mapItem: MKMapItem
    // True when Apple Maps matched the pastry name, not just "bakery nearby".
    // Apple Maps has no menu data, so this means "likely has it", not "sells it".
    let hasPastry: Bool
}
