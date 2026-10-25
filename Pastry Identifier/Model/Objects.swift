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
    Pastry(name: "Cookie", origin: "Persia", description: "A small sweet, crispy or cake like pastry most often made with flour, sugar, liquid and fat. Persia was among the first regions to cultivate sugar cane, making cakes and pastries a well known delicacy within the Persian Empire (Modern-day Iran)."),
    Pastry(name: "Kouign Amann", origin: "France", description: "A Breton cake containing layers of butter and sugar folded in, similar in fashion to puff pastry albeit with fewer layers. The sugar caramelizes during baking. The name derives from the Breton words for cake ('kouign') and butter ('amann')."),
    Pastry(name: "Danish", origin: "Denmark", description: "A sweet pastry, of Viennese origin, which has become a speciality of Denmark and neighboring Scandinavian countries. Called 'facturas' in Argentina and neighbouring countries"),
    Pastry(name: "Scone", origin: "Scotland", description: "A lightly sweetened baked good traditionally made with flour, butter, sugar and milk. Scones are thought to have originated in Scotland in the early 1500s, with the first known print reference made by a Scottish poet in 1513."),
]

// Label and confidence note from the classifier
struct PastryClassification: Equatable {
    let name: String
    let note: String
}
