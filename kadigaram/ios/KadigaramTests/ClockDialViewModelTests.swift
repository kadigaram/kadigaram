//
//  ClockDialViewModelTests.swift
//  KadigaramTests
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T013 - ClockDialViewModel Tests
//

import XCTest
@testable import Kadigaram

@MainActor
final class ClockDialViewModelTests: XCTestCase {
    
    var viewModel: ClockDialViewModel!
    
    override func setUp() async throws {
        viewModel = ClockDialViewModel()
    }
    
    override func tearDown() async throws {
        viewModel.stopUpdating()
        viewModel = nil
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        // Then
        XCTAssertNotNil(viewModel.currentTime)
        XCTAssertNotNil(viewModel.design)
    }
    
    func testInitializationWithCustomTime() {
        // Given
        let customTime = Date(timeIntervalSince1970: 1000000)
        
        // When
        let vm = ClockDialViewModel(currentTime: customTime)
        
        // Then
        XCTAssertEqual(vm.currentTime, customTime)
    }
    
    // MARK: - Hour Hand Angle Tests
    
    func testHourHandAngleAt12Oclock() {
        // Given - 12:00
        var components = DateComponents()
        components.hour = 12
        components.minute = 0
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.hourHandAngle()
        
        // Then - should be 0°  (12 o'clock position)
        XCTAssertEqual(angle, 0.0, accuracy: 0.01)
    }
    
    func testHourHandAngleAt3Oclock() {
        // Given - 3:00
        var components = DateComponents()
        components.hour = 3
        components.minute = 0
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.hourHandAngle()
        
        // Then - should be 90° (3 o'clock position)
        XCTAssertEqual(angle, 90.0, accuracy: 0.01)
    }
    
    func testHourHandAngleAt6Oclock() {
        // Given - 6:00
        var components = DateComponents()
        components.hour = 6
        components.minute = 0
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.hourHandAngle()
        
        // Then - should be 180° (6 o'clock position)
        XCTAssertEqual(angle, 180.0, accuracy: 0.01)
    }
    
    func testHourHandAngleAt9Oclock() {
        // Given - 9:00
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.hourHandAngle()
        
        // Then - should be 270° (9 o'clock position)
        XCTAssertEqual(angle, 270.0, accuracy: 0.01)
    }
    
    func testHourHandAngleWithMinutes() {
        // Given - 3:30 (hour hand should be halfway between 3 and 4)
        var components = DateComponents()
        components.hour = 3
        components.minute = 30
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.hourHandAngle()
        
        // Then - should be 105° (90° + 15° for 30 minutes)
        XCTAssertEqual(angle, 105.0, accuracy: 0.01)
    }
    
    // MARK: - Minute Hand Angle Tests
    
    func testMinuteHandAngleAt0Minutes() {
        // Given - :00
        var components = DateComponents()
        components.hour = 3
        components.minute = 0
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.minuteHandAngle()
        
        // Then - should be 0°
        XCTAssertEqual(angle, 0.0, accuracy: 0.01)
    }
    
    func testMinuteHandAngleAt15Minutes() {
        // Given - :15
        var components = DateComponents()
        components.hour = 3
        components.minute = 15
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.minuteHandAngle()
        
        // Then - should be 90° (15 * 6)
        XCTAssertEqual(angle, 90.0, accuracy: 0.01)
    }
    
    func testMinuteHandAngleAt30Minutes() {
        // Given - :30
        var components = DateComponents()
        components.hour = 3
        components.minute = 30
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.minuteHandAngle()
        
        // Then - should be 180° (30 * 6)
        XCTAssertEqual(angle, 180.0, accuracy: 0.01)
    }
    
    func testMinuteHandAngleAt45Minutes() {
        // Given - :45
        var components = DateComponents()
        components.hour = 3
        components.minute = 45
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.minuteHandAngle()
        
        // Then - should be 270° (45 * 6)
        XCTAssertEqual(angle, 270.0, accuracy: 0.01)
    }
    
    // MARK: - Second Hand Angle Tests
    
    func testSecondHandAngleAt0Seconds() {
        // Given
        var components = DateComponents()
        components.hour = 3
        components.minute = 30
        components.second = 0
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.secondHandAngle()
        
        // Then
        XCTAssertEqual(angle, 0.0, accuracy: 0.01)
    }
    
    func testSecondHandAngleAt30Seconds() {
        // Given
        var components = DateComponents()
        components.hour = 3
        components.minute = 30
        components.second = 30
        let time = Calendar.current.date(from: components)!
        viewModel.setTime(time)
        
        // When
        let angle = viewModel.secondHandAngle()
        
        // Then - should be 180° (30 * 6)
        XCTAssertEqual(angle, 180.0, accuracy: 0.01)
    }
    
    // MARK: - Update Time Tests
    
    func testUpdateTime() {
        // Given
        let oldTime = viewModel.currentTime
        
        // When - wait a tiny bit and update
        Thread.sleep(forTimeInterval: 0.01)
        viewModel.updateTime()
        
        // Then - time should have changed
        XCTAssertNotEqual(viewModel.currentTime, oldTime)
    }
    
    func testSetTime() {
        // Given
        let specificTime = Date(timeIntervalSince1970: 500000)
        
        // When
        viewModel.setTime(specificTime)
        
        // Then
        XCTAssertEqual(viewModel.currentTime, specificTime)
    }
    
    // MARK: - Design Application Tests
    
    func testApplyIconDesign() {
        // Given
        let iconColors = ImageColorExtraction.DialColorPalette.default
        
        // When
        viewModel.applyIconDesign(iconColors: iconColors)
        
        // Then - design should have been updated
        XCTAssertNotNil(viewModel.design)
        XCTAssertNotNil(viewModel.design.colorPalette)
    }
    
    func testApplyCustomDesign() {
        // Given
        let customDesign = ClockDialDesign.default
        
        // When
        viewModel.applyDesign(customDesign)
        
        // Then
        XCTAssertEqual(viewModel.design.geometry.concentricRings, customDesign.geometry.concentricRings)
    }
    
    // MARK: - Preview Helper Tests
    
    func testPreviewHelper() {
        // When
        let previewVM = ClockDialViewModel.preview(hour: 10, minute: 10)
        
        // Then
        let calendar = Calendar.current
        XCTAssertEqual(calendar.component(.hour, from: previewVM.currentTime), 10)
        XCTAssertEqual(calendar.component(.minute, from: previewVM.currentTime), 10)
    }
}
