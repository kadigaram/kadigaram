# Research: Moon Phase Arrow and Nakshatra Display

**Feature**: 008-moon-nakshatra-ui
**Date**: 2026-01-29

## Summary

Minimal research required - this feature uses existing data and patterns in the codebase.

## Research Tasks

### Task 1: Arrow Icon Options

**Decision**: Use SF Symbols `chevron.up` and `chevron.down`

**Rationale**: 
- Native iOS symbols available since iOS 14 (meets N-1 compatibility requirement)
- Lightweight, scalable vector graphics
- Matches existing codebase pattern (MoonPhaseView uses SF Symbols for moon phases)
- Subtle appearance at small sizes

**Alternatives Considered**:
| Option | Pros | Cons |
|--------|------|------|
| `arrow.up` / `arrow.down` | More prominent | Too visually heavy at small size |
| `triangle.fill` (rotated) | Simple | Requires rotation transforms |
| Unicode arrows (▲ ▼) | Platform agnostic | Inconsistent rendering, not SF Symbol |

### Task 2: Nakshatra Data Availability

**Decision**: Use existing `vedicDate.nakshatra` property

**Rationale**:
- VedicDate model already includes `nakshatra: String` (localization key like "nakshatra_ashwini")
- VedicEngine already calculates Nakshatra based on moon's ecliptic longitude
- All 27 Nakshatra names already have Tamil translations in `ta.lproj/Localizable.strings`

**Verification**:
- Confirmed in `VedicDate.swift`: Lines 24-26 define nakshatra, nakshatraProgress, nakshatraNumber
- Confirmed in `VedicEngine.swift`: Lines 60-78 calculate and assign nakshatra
- Confirmed in `ta.lproj/Localizable.strings`: All 27 nakshatra translations present

### Task 3: Layout Placement

**Decision**: Arrow inline with moon icon, Nakshatra as new row below date row

**Rationale**:
- Inline arrow keeps the compact first impression while adding information
- Separate Nakshatra row provides clear visual hierarchy
- Matches user's explicit request: "add Nakshatram label below the row"

## Unknowns Resolved

| Unknown | Resolution |
|---------|------------|
| Arrow size/style | Use SF Symbol chevron at `.caption2` font size |
| Nakshatra data source | Use existing `vedicDate.nakshatra` |
| Localization | Use existing `bhashaEngine.localizedString()` |

## No Clarifications Needed

All requirements are clear from the specification and existing codebase patterns.
