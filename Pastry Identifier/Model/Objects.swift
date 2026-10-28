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
    let allergens: [FoodAttribute]?             // Missing when FatSecret has no data
    let dietaryPreferences: [FoodAttribute]?
}

// An allergen or diet flag; nil value means unknown, not "free of"
struct FoodAttribute: Decodable {
    let name: String
    let value: Bool?
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
    // Matched the pastry name (likely has it, not confirmed)
    let hasPastry: Bool
}

// Strict typing
struct Pastry: Identifiable {
    var name: String
    var origin: String
    var description: String
    var id: String { name }
}

// Get Patry information
func getPastry(name: String) -> Pastry? {
    return pastries.first { $0.name.lowercased() == name.lowercased() }
}
// Create pastry data for display
var pastries: [Pastry] = [
    Pastry(name: "Croissant", origin: "France", description: "A buttery flaky bread named for its distinctive crescent shape. Croissants are made of a leavened variant of puff pastry. The yeast dough is layered with butter, rolled and folded several times in succession, then rolled into a sheet, a technique called laminating. Croissants have long been a staple of French bakeries and pâtisseries."),
    Pastry(name: "Cookie", origin: "Persia", description: "A versatile sweet treat offering a delightful balance of crisp edges and tender bite. Originating in ancient Persia, where sugarcane was first cultivated in abundance, these small baked treats evolved into a beloved staple enjoyed worldwide."),
    Pastry(name: "Kouign Amann", origin: "France", description: "A celebrated specialty from Brittany, France, featuring slow folded layers of dough, butter, and sugar. As it bakes, the sugar caramelizes into a glossy, crisp crust surrounding a soft, rich center. Its name simply and accurately translates from Breton as 'cake' (kouign) and 'butter' (amann)."),
    Pastry(name: "Danish", origin: "Denmark", description: "A tender, multi layered pastry filled with sweet jams, fruit, or custards. Born from Viennese baking techniques brought to Denmark by Austrian bakers, it became a Scandinavian hallmark and spread internationally."),
    Pastry(name: "Scone", origin: "Scotland", description: "A lightly sweetened baked good traditionally made with flour, butter, sugar and milk. Scones are thought to have originated in Scotland in the early 1500s, with the first known print reference made by a Scottish poet in 1513."),
]

// Label and confidence note from the classifier
struct PastryClassification: Equatable {
    let name: String
    let note: String
}
