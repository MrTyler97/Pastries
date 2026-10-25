//
//  CameraServiceTests.swift
//  Pastry IdentifierTests
//
//  Flash cycling and zoom clamping.
//

import XCTest
import AVFoundation
@testable import Pastry_Identifier

final class CameraServiceTests: XCTestCase {

    func testFlashCyclesOffAutoOn() {
        XCTAssertEqual(CameraService.nextFlashMode(after: .off), .auto)
        XCTAssertEqual(CameraService.nextFlashMode(after: .auto), .on)
        XCTAssertEqual(CameraService.nextFlashMode(after: .on), .off)
    }

    func testZoomClampsToRange() {
        // Below 1x
        XCTAssertEqual(CameraService.clampedZoom(0.5, deviceMax: 10), 1)
        // Above maxZoom
        XCTAssertEqual(CameraService.clampedZoom(8, deviceMax: 10), CameraService.maxZoom)
        // Device limit lower than maxZoom
        XCTAssertEqual(CameraService.clampedZoom(4, deviceMax: 3), 3)
    }

    func testZoomInRangeIsUnchanged() {
        XCTAssertEqual(CameraService.clampedZoom(2.5, deviceMax: 10), 2.5)
    }
}
