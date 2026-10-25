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
