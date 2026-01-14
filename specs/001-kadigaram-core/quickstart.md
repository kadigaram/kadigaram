# Quickstart: Kadigaram Core Verification

How to verify the Phase 1 implementation.

## Prerequisites
- Xcode 15+
- iOS 17+ Simulator

## Manual Verification Steps

### 1. Verify Vedic Calculation
**Action**: Run Unit Tests for `VedicEngine`.
**Expected**: 
- Input: Chennai, Jan 14 06:00 AM (Sunrise).
- Output: Nazhigai 00:00.

### 2. Verify Language Switching (Bhasha)
**Action**: 
1. Launch App. Default English. Date says "Wednesday".
2. Tap "A/अ" -> Select "Tamil".
3. Date should immediately update to "புதன்" (Budhan).

### 3. Verify Offline Location Fallback
**Action**: 
1. Deny Location Permission on startup.
2. Tap "Enter Location".
3. Type "Che".
4. Select "Chennai" from list.
5. Nazhigai wheel should start spinning.
