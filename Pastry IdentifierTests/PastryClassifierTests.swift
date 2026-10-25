//
//  PastryClassifierTests.swift
//  Pastry IdentifierTests
//
//  Confidence thresholds map to the right label and note.
//

import XCTest
@testable import Pastry_Identifier

final class PastryClassifierTests: XCTestCase {

    func testOtherIsNotApplicable() {
        XCTAssertEqual(PastryClassifier.result(for: "Other", confidence: 0.99).name, "Not Applicable")
    }

    func testHighConfidence() {
        let result = PastryClassifier.result(for: "Croissant", confidence: 0.95)
        XCTAssertEqual(result, PastryClassification(name: "Croissant", note: "High Confidence"))
    }

    func testLowConfidence() {
        let result = PastryClassifier.result(for: "Scone", confidence: 0.7)
        XCTAssertEqual(result.name, "Scone")
        XCTAssertEqual(result.note, "Low Confidence - may be misclassified")
    }

    func testVeryLowConfidenceIsUnclassified() {
        XCTAssertEqual(PastryClassifier.result(for: "Danish", confidence: 0.3).name, "Unclassified")
    }
}
