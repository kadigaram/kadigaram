import XCTest
import SixPartsLib
@testable import KadigaramCore

/// Unit tests for MoonPhaseView arrow direction logic
final class MoonPhaseViewTests: XCTestCase {
    
    // MARK: - Arrow Direction Tests
    
    /// Test that Shukla Paksha (waxing) returns up chevron symbol
    func testShuklaPhakshaReturnsUpArrow() {
        // Given Shukla Paksha (waxing moon)
        let paksha = Paksha.shukla
        
        // When we determine the arrow direction
        let arrowSymbol = MoonPhaseView.arrowSymbolName(for: paksha)
        
        // Then it should be chevron.up
        XCTAssertEqual(arrowSymbol, "chevron.up", "Shukla Paksha (waxing) should show up arrow")
    }
    
    /// Test that Krishna Paksha (waning) returns down chevron symbol
    func testKrishnaPhakshaReturnsDownArrow() {
        // Given Krishna Paksha (waning moon)
        let paksha = Paksha.krishna
        
        // When we determine the arrow direction
        let arrowSymbol = MoonPhaseView.arrowSymbolName(for: paksha)
        
        // Then it should be chevron.down
        XCTAssertEqual(arrowSymbol, "chevron.down", "Krishna Paksha (waning) should show down arrow")
    }
}
