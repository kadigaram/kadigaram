# Research: UI and Calculation Enhancements

## Decision 1: Astronomical Library for Vedic Calculations

**Decision**: Use SwissEphemeris Swift wrapper or pure Swift astronomical calculation library

**Rationale**:
- Swiss Ephemeris is the gold standard for astronomical calculations
- Used by professional astronomers and astrologers worldwide
- Provides high-precision planetary positions, sunrise/sunset, moon phases
- Several Swift wrappers available or we can create a minimal C bridge

**Alternatives Considered**:
1. **Build from scratch**: Too complex, error-prone, reinventing the wheel
2. **Use web API (Dhrik Panchang API)**: Network dependency, offline won't work, latency
3. **Simplified formulas**: Insufficient accuracy for religious/cultural use

**Implementation Approach**:
- Research Swift wrappers for Swiss Ephemeris (e.g., via GitHub search)
- If no suitable wrapper exists, create minimal XCFramework wrapper around SwissEph C library
- Fallback: Use well-tested astronomical formulas from reputable sources (Meeus algorithms)

## Decision 2: 3D Embossed Style Implementation

**Decision**: Use SwiftUI gradients, shadows, and overlay effects

**Rationale**:
- Native SwiftUI provides sufficient tools for embossed appearance
- No external dependencies needed
- Performant and lightweight

**Alternatives Considered**:
- Custom Core Graphics rendering: Overkill, harder to maintain
- External UI libraries: Violates constitution (native-first)

## Decision 3: Dhrik Panchang as Verification Source

**Decision**: Manual comparison testing against Dhrik Panchang website

**Rationale**:
- Dhrik Panchang is widely trusted and accurate
- User specifically mentioned it as reference
- No API available, so manual verification is most practical

**Test Data Strategy**:
- Create test cases for 10-20 known dates across different years
- Include edge cases (Adhik Maasa, intercalary periods)
- Test multiple locations (different latitudes)
