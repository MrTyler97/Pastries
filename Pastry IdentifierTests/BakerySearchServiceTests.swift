//
//  BakerySearchServiceTests.swift
//  Pastry IdentifierTests
//
//  Merge, dedupe, radius filter, and sort of the two search passes.
//

import XCTest
import MapKit
@testable import Pastry_Identifier

final class BakerySearchServiceTests: XCTestCase {
    let service = BakerySearchService()
    // Paris
    let center = CLLocation(latitude: 48.8566, longitude: 2.3522)

    // Place north of the center; 0.01° latitude ≈ 1.1 km
    func place(_ name: String, northBy degrees: Double) -> MKMapItem {
        let location = CLLocation(latitude: center.coordinate.latitude + degrees, longitude: center.coordinate.longitude)
        let item = MKMapItem(location: location, address: nil)
        item.name = name
        return item
    }

    func testPastryPassIsMarkedAsMatch() {
        let results = service.merge(
            pastryPlaces: [place("Match", northBy: 0.01)],
            nearbyPlaces: [place("Other", northBy: 0.02)],
            center: center
        )
        XCTAssertEqual(results.map(\.mapItem.name), ["Match", "Other"])
        XCTAssertEqual(results.map(\.hasPastry), [true, false])
    }

    func testNoPastryMarksNothingAsMatch() {
        let results = service.merge(
            pastryPlaces: [place("Bakery", northBy: 0.01)],
            nearbyPlaces: [place("Cafe", northBy: 0.02)],
            center: center,
            markMatches: false
        )
        XCTAssertEqual(results.map(\.mapItem.name), ["Bakery", "Cafe"])
        XCTAssertEqual(results.map(\.hasPastry), [false, false])
    }

    func testDuplicateKeepsPastryMatch() {
        let results = service.merge(
            pastryPlaces: [place("Same", northBy: 0.01)],
            nearbyPlaces: [place("Same", northBy: 0.01)],
            center: center
        )
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.hasPastry, true)
    }

    func testDropsPlacesOutsideRadius() {
        // ~16.7 km away, radius is 10 km
        let results = service.merge(
            pastryPlaces: [place("Far", northBy: 0.15)],
            nearbyPlaces: [place("Near", northBy: 0.01)],
            center: center
        )
        XCTAssertEqual(results.map(\.mapItem.name), ["Near"])
    }

    func testSortsNearestFirst() {
        let results = service.merge(
            pastryPlaces: [place("Third", northBy: 0.05)],
            nearbyPlaces: [place("Second", northBy: 0.02), place("First", northBy: 0.01)],
            center: center
        )
        XCTAssertEqual(results.map(\.mapItem.name), ["First", "Second", "Third"])
    }

    func testEmptyPassesGiveNoResults() {
        let results = service.merge(pastryPlaces: [], nearbyPlaces: [], center: center)
        XCTAssertTrue(results.isEmpty)
    }
}
