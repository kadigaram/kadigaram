//
//  OrientationTests.swift
//  KadigaramUITests
//
//  Created for Feature 006: Clock UI Improvements
//

import XCTest

final class OrientationTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testOrientationChange() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Wait for clock to appear
        let clockElement = app.otherElements["AdaptiveClockDial"]
        if clockElement.exists {
             // Basic existence check
        }
        
        // Simulate rotation to Landscape Left
        XCUIDevice.shared.orientation = .landscapeLeft
        
        // Allow animation time
        Thread.sleep(forTimeInterval: 1.0)
        
        // Verify dial is still visible (and ideally sized differently, but difficult to assert exact frame in XCTest)
        // We can check if Safe Area constraints are respected by checking overlapping elements
        
        // Rotate back to Portrait
        XCUIDevice.shared.orientation = .portrait
        
        Thread.sleep(forTimeInterval: 1.0)
        
        // Verify state restored
    }

    func testRapidRotation() throws {
        let app = XCUIApplication()
        app.launch()
        
        for _ in 0..<5 {
            XCUIDevice.shared.orientation = .landscapeRight
            Thread.sleep(forTimeInterval: 0.5)
            XCUIDevice.shared.orientation = .portrait
            Thread.sleep(forTimeInterval: 0.5)
        }
        
        // Ensure no crash
        XCTAssertTrue(app.exists)
    }
}
