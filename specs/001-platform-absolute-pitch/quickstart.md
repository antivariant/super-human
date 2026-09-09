# Quickstart: Plugin-Based Training Platform with Absolute Pitch MVP

## Goal

Validate plugin catalog, Absolute Pitch session flow (including replay current note), cooldown enforcement, and per-plugin dashboard trends.

## Preconditions

- Running feature branch: `001-platform-absolute-pitch`
- Local persistence initialized
- Absolute Pitch plugin registered in plugin catalog
- No network dependency required for active training flow
- Flutter SDK available for local desktop + emulator runs

## Validation Flow

1. Launch the native desktop application.
2. Open plugin catalog and confirm Absolute Pitch appears as an available plugin.
3. Start Absolute Pitch session.
4. Confirm note playback starts with keyboard hidden.
5. Confirm keyboard appears only after playback ends.
6. Press replay before submitting an answer.
7. Verify the same current note is replayed (no new random note generated).
8. Submit one answer via keyboard or voice.
9. Verify result is strictly boolean: correct/incorrect.
10. Attempt a second guess for the same note and verify rejection.
11. Attempt replay after submission and verify replay is disabled.
12. Immediately request next random note or repeat test and verify lock message.
13. Wait less than 10 minutes and verify request remains blocked.
14. Wait until 10 minutes have elapsed and verify next note/repeat becomes available.
15. Complete session and restart app.
16. Verify session results remain present in local history.
17. Open global dashboard and verify:
   - metrics are separated per plugin,
   - no cross-plugin aggregate score,
   - daily trend direction shown for each plugin with history.
18. Confirm out-of-scope behavior:
   - no multiplayer modes,
   - no leaderboards,
   - no cross-user score comparison.

## Test Focus Areas

- Deterministic attempt evaluation for repeated seeded runs
- Replay semantics for current note only
- One-guess rule preserved after replay usage
- Cooldown enforcement at both plugin-session and per-note pacing levels
- Offline-only behavior during active session
- Trend calculations by day instead of cumulative totals

## Expected Outcomes

- One valid submitted guess per note
- Unlimited answer time before first valid submission
- Replay button replays current note without changing attempt prompt
- Replay disabled after valid submission
- 10-minute delay enforced before next note/repeat
- Stable local persistence and reproducible trend views
