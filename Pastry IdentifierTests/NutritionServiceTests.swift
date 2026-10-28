//
//  NutritionServiceTests.swift
//  Pastry IdentifierTests
//
//  Decoding of proxy responses and error handling that needs no network.
//

import XCTest
@testable import Pastry_Identifier

final class NutritionServiceTests: XCTestCase {

    func testDecodesFullFood() throws {
        let json = """
        {"foodId": "3533", "name": "Croissant", "brand": null, "servings": [
          {"servingId": "1", "description": "1 medium", "grams": 57, "calories": 231,
           "carbs": 26.1, "protein": 4.7, "fat": 12, "saturatedFat": 6.6, "sugar": 6.4,
           "fiber": 1.5, "sodium": 424, "cholesterol": 38}
        ]}
        """
        let food = try JSONDecoder().decode(PastryFood.self, from: Data(json.utf8))
        XCTAssertEqual(food.name, "Croissant")
        XCTAssertNil(food.brand)
        XCTAssertEqual(food.servings.first?.calories, 231)
        XCTAssertEqual(food.servings.first?.sodium, 424)
    }

    func testDecodesServingWithoutOptionalFields() throws {
        let json = """
        {"foodId": "3936", "name": "Cookie", "servings": [
          {"servingId": "1", "description": "1 cookie", "calories": 78,
           "carbs": 10, "protein": 1, "fat": 4}
        ]}
        """
        let food = try JSONDecoder().decode(PastryFood.self, from: Data(json.utf8))
        let serving = try XCTUnwrap(food.servings.first)
        XCTAssertNil(serving.grams)
        XCTAssertNil(serving.sugar)
        XCTAssertNil(serving.cholesterol)
    }

    func testDecodesAllergensWithUnknownValues() throws {
        let json = """
        {"foodId": "3533", "name": "Croissant", "servings": [],
         "allergens": [{"name": "Milk", "value": true}, {"name": "Fish", "value": false},
                       {"name": "Nuts", "value": null}],
         "dietaryPreferences": [{"name": "Vegan", "value": false}]}
        """
        let food = try JSONDecoder().decode(PastryFood.self, from: Data(json.utf8))
        let allergens = try XCTUnwrap(food.allergens)
        // Look up by name; order isn't guaranteed
        XCTAssertEqual(allergens.first { $0.name == "Milk" }?.value, true)
        XCTAssertEqual(allergens.first { $0.name == "Fish" }?.value, false)
        let nuts = try XCTUnwrap(allergens.first { $0.name == "Nuts" })
        XCTAssertNil(nuts.value)
        XCTAssertEqual(food.dietaryPreferences?.first?.value, false)
    }

    func testMissingAllergenKeysDecodeAsNil() throws {
        let json = """
        {"foodId": "3936", "name": "Cookie", "servings": []}
        """
        let food = try JSONDecoder().decode(PastryFood.self, from: Data(json.utf8))
        XCTAssertNil(food.allergens)
        XCTAssertNil(food.dietaryPreferences)
    }

    func testTrueNamesKeepsOnlyContainedSorted() {
        let attributes = [
            FoodAttribute(name: "Soy", value: false),
            FoodAttribute(name: "Nuts", value: nil),
            FoodAttribute(name: "Milk", value: true),
            FoodAttribute(name: "Eggs", value: true),
        ]
        XCTAssertEqual(attributes.trueNames(), ["Eggs", "Milk"])
        XCTAssertTrue(attributes.hasUnknown)
    }

    func testNoUnknownWhenAllValuesKnown() {
        let attributes = [
            FoodAttribute(name: "Milk", value: true),
            FoodAttribute(name: "Fish", value: false),
        ]
        XCTAssertFalse(attributes.hasUnknown)
    }

    func testMissingRequiredFieldFailsToDecode() {
        // No calories
        let json = """
        {"foodId": "1", "name": "Bad", "servings": [
          {"servingId": "1", "description": "1", "carbs": 1, "protein": 1, "fat": 1}
        ]}
        """
        XCTAssertThrowsError(try JSONDecoder().decode(PastryFood.self, from: Data(json.utf8)))
    }

    func testUnknownLabelThrowsNotFound() async {
        // Fails before any network call
        do {
            _ = try await NutritionService().food(forClassLabel: "Baguette")
            XCTFail("Expected notFound")
        } catch NutritionError.notFound {
            // Expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testErrorMessages() {
        XCTAssertEqual(NutritionError.notFound.message, "No nutrition data for this pastry")
        XCTAssertEqual(NutritionError.rateLimited(retryAfter: 30).message, "Too many requests, try again shortly")
        XCTAssertEqual(NutritionError.quotaExhausted.message, "Nutrition data unavailable today, try again tomorrow")
        XCTAssertEqual(NutritionError.unauthorized.message, "Couldn't load nutrition data")
        XCTAssertEqual(NutritionError.upstream.message, "Couldn't load nutrition data")
    }
}
