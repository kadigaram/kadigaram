# Research: Manual Location Entry

**Decision**: Use `MapKit`'s `MKLocalSearch` for location search.
**Rationale**: Native iOS API, reliable, standard behavior, requires no extra dependencies or API keys (uses device quotas).
**Alternatives Considered**:
- **Google Places API**: Requires API key, billing setup, and custom networking. Overkill for this MVP.
- **Geonames API**: Free tier limits, requires networking logic.
- **Local Database**: Hard to maintain 1000s of cities, increases app size.

**Unknowns Resolved**:
- **Timezone**: `MKLocalSearch` results (`MKMapItem`) contain `timeZone`. We can use this directly.
