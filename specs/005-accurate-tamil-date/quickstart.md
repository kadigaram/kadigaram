# Quick Start: SixPartsLib

**Feature**: 005-accurate-tamil-date  
**Library**: SixPartsLib — Vedic and Tamil calendar calculations

## Installation

### 1. Add SixPartsLib to KadigaramCore

**File**: `kadigaram/ios/KadigaramCore/Package.swift`

```swift
// Add local package dependency
dependencies: [
    .package(url: "https://github.com/ceeK/Solar.git", from: "3.0.0"),
    .package(path: "../SixPartsLib"),  // Local package
],

targets: [
    .target(
        name: "KadigaramCore",
        dependencies: [
            .product(name: "Solar", package: "Solar"),
            .product(name: "SixPartsLib", package: "SixPartsLib"),  // Add dependency
        ]
    ),
]
```

### 2. Create SixPartsLib Package

**Location**: `kadigaram/ios/SixPartsLib/`

**Command** (run from `kadigaram/ios/`):
```bash
mkdir SixPartsLib
cd SixPartsLib
swift package init --type library --name SixPartsLib
```

This generates:
```
SixPartsLib/
├── Package.swift
├── Sources/SixPartsLib/
│   └── SixPartsLib.swift
└── Tests/SixPartsLibTests/
    └── SixPartsLibTests.swift
```

---

## Basic Usage

### Import in Swift Files

```swift
import SixPartsLib
import CoreLocation
```

### Calculate Tamil Date

```swift
let location = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)  // Chennai
let timeZone = TimeZone(identifier: "Asia/Kolkata")!

let tamilDate = SixPartsLib.calculateTamilDate(
    for: Date(),
    location: location,
    timeZone: timeZone
)

print("Tamil Date: \(tamilDate.monthName) \(tamilDate.dayNumber)")
// Output: "Tamil Date: month_thai 5"
```

### Calculate Vedic Date (Existing)

```swift
let vedicDate = await SixPartsLib.calculateVedicDate(
    for: Date(),
    location: location,
    calendarSystem: .solar
)

print("Vedic Year: \(vedicDate.samvatsara)")
print("Tithi: \(vedicDate.tithi)")
print("Nakshatra: \(vedicDate.nakshatra)")
```

---

## Running Tests

### Unit Tests (Xcode)

**From Xcode**:
1. Open `kadigaram/ios/kadigaram.xcodeproj`
2. Select `SixPartsLib` scheme
3. Press **Cmd + U** to run tests

**From Terminal**:
```bash
cd kadigaram/ios/SixPartsLib
swift test
```

### Expected Output

```
Test Suite 'All tests' started
Test Suite 'TamilCalendarTests' started
  ✓ testTamilNewYear2026        (0.045 seconds)
  ✓ testThaiMonthTransition      (0.038 seconds)
  ✓ testSunsetRuleEdgeCase       (0.042 seconds)
  ✓ testLeapYearHandling         (0.035 seconds)
Test Suite 'TamilCalendarTests' passed
Test Suite 'SankrantiTests' started
  ✓ testBinarySearchAccuracy     (0.052 seconds)
  ✓ testRasiBoundaryWraparound   (0.040 seconds)
Test Suite 'SankrantiTests' passed
Test Suite 'All tests' passed (0.252 seconds)
```

### Test with Real Data

Reference test data from Dhrik Panchang:

```swift
func testAgainstDhrikPanchang() {
    // Jan 14, 2026 — Expected: Thai 1
    let date = dateFrom(year: 2026, month: 1, day: 14)
    let tamilDate = SixPartsLib.calculateTamilDate(for: date, location: chennai, timeZone: ist)
    
    XCTAssertEqual(tamilDate.monthName, "month_thai")
    XCTAssertEqual(tamilDate.dayNumber, 1)
}
```

---

## Integration in Main App

### Update VedicEngine

**File**: `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/VedicEngine.swift`

**Before** (old implementation):
```swift
import Foundation
import Solar

public class VedicEngine {
    // Old calculations here
}
```

**After** (using SixPartsLib):
```swift
import Foundation
import Solar
import SixPartsLib  // Add import

public class VedicEngine {
    public func calculateVedicDate(...) async -> VedicDate {
        // Delegate to SixPartsLib
        return await SixPartsLib.calculateVedicDate(
            for: date,
            location: location,
            calendarSystem: calendarSystem
        )
    }
}
```

### Add Tamil Date to UI

**File**: `kadigaram/ios/Kadigaram/UI/Screens/DashboardView.swift`

```swift
import SixPartsLib

struct DashboardView: View {
    @State private var tamilDate: TamilDate?
    
    var body: some View {
        VStack {
            // Existing Vedic date display
            
            // New: Tamil date display
            if let tamil = tamilDate {
                Text("தமிழ் தேதி: \(tamil.monthName) \(tamil.dayNumber)")
                    .font(.headline)
            }
        }
        .task {
            tamilDate = SixPartsLib.calculateTamilDate(
                for: Date(),
                location: viewModel.location,
                timeZone: .current
            )
        }
    }
}
```

---

## Debugging

### Enable Verbose Logging

Add to `TamilCalendarCalculator.swift`:

```swift
func findSankranti(targetDegree: Double, searchEnd: Date) -> Date? {
    #if DEBUG
    print("[DEBUG] Searching for Sankranti at \(targetDegree)°")
    #endif
    
    // ... binary search logic ...
    
    #if DEBUG
    print("[DEBUG] Found Sankranti at \(result)")
    #endif
    
    return result
}
```

### Verify Sankranti Accuracy

```swift
let sankrantiTime = tamilDate.sankrantiTimestamp
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd HH:mm"
print("Sankranti: \(formatter.string(from: sankrantiTime))")

// Compare with Dhrik Panchang manually:
// https://www.drikpanchang.com/panchang/month-panchang.html
```

---

## Common Issues

### Issue: "Cannot find 'SixPartsLib' in scope"

**Solution**: Ensure Package.swift includes the dependency and rebuild:
```bash
cd kadigaram/ios
swift package resolve
xcodebuild clean build
```

### Issue: Tamil day number is off by 1

**Cause**: Sunset rule not applied correctly.

**Debug**:
```swift
print("Sankranti: \(sankrantiTime)")
print("Sunset: \(sunsetTime)")
print("Is Day One: \(sankrantiTime < sunsetTime)")
```

### Issue: Tests fail with "Sankranti not found"

**Cause**: Search window too small or date outside 2020-2030 range.

**Fix**: Extend search window in `findSankranti()`:
```swift
let searchStart = Calendar.current.date(byAdding: .day, value: -45, to: searchEnd)!  // Increase from 32 to 45
```

---

## Performance Benchmarks

**Target**: Tamil date calculation < 50ms

**Benchmark Code**:
```swift
func testPerformance() {
    measure {
        _ = SixPartsLib.calculateTamilDate(
            for: Date(),
            location: CLLocationCoordinate2D(latitude: 13.0, longitude: 80.0),
            timeZone: .current
        )
    }
}
```

**Expected Results**:
- Debug build: ~30-40ms
- Release build: ~15-25ms
- Binary search iterations: ~12-15 (log₂(32 days / 1 minute))

---

## Next Steps

1. **Implement SixPartsLib**: Follow [tasks.md](tasks.md) (created by `/speckit.tasks`)
2. **Write Tests**: Add unit tests in `Tests/SixPartsLibTests/`
3. **Integrate**: Update `VedicEngine` to use SixPartsLib
4. **Verify**: Compare with Dhrik Panchang for 10+ test dates
5. **Ship**: Merge branch and deploy to TestFlight

**Questions?** See [research.md](research.md) for algorithm details or [data-model.md](data-model.md) for API reference.
