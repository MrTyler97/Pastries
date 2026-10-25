//
//  PastryDataTests.swift
//  Pastry IdentifierTests
//
//  Pastry names must line up with assets and nutrition food_ids.
//

import XCTest
import UIKit
@testable import Pastry_Identifier

final class PastryDataTests: XCTestCase {

    func testEveryPastryHasAnAssetImage() {
        for pastry in pastries {
            XCTAssertNotNil(UIImage(named: pastry.name), "Missing asset for \(pastry.name)")
        }
    }

    func testEveryPastryHasAFoodId() {
        let foodIds = NutritionService().foodIds
        for pastry in pastries {
            XCTAssertNotNil(foodIds[pastry.name.lowercased()], "Missing food_id for \(pastry.name)")
        }
    }

    func testGetPastryIgnoresCase() {
        XCTAssertEqual(getPastry(name: "kouign amann")?.name, "Kouign Amann")
        XCTAssertNil(getPastry(name: "Not Applicable"))
    }
}
