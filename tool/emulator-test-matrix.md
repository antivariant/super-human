# Emulator Test Matrix

## iOS Simulator

- Device: iPhone 15
- OS: iOS 17+
- Scenario: open plugin catalog -> launch Absolute Pitch -> submit one guess -> verify lock
- Expected: no crash, session persistence intact, next note locked for 10 minutes

## Android Emulator

- Device: Pixel 7
- API: 34+
- Scenario: open dashboard after session completion
- Expected: per-plugin stats shown, no unified score

## Run Hints

- `flutter test`
- `flutter test integration_test`
- `flutter run -d iOS`
- `flutter run -d android`
