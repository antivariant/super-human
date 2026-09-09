# Performance Report

Date: 2026-02-13
Feature: 001-platform-absolute-pitch

## Objective

Validate the session-path latency target from constitution and plan (`< 50ms` response budget for active training loop operations).

## Method

Executed deterministic micro-profile script:

- Command: `dart run tool/perf_profile.dart`
- Workload per iteration:
  - start attempt
  - submit one guess
  - compute next-note eligibility
- Iterations: `5000`

## Results

- `iterations=5000`
- `total_ms=26.012`
- `avg_ms=0.005202`

## Interpretation

The measured average operation time (`0.005202ms`) is well below the `<50ms` target for active session-path logic.

## Notes

- This profile measures core in-process logic, not full UI/render/audio stack.
- End-to-end runtime behavior is additionally covered by integration tests and should be profiled on target hardware during release hardening.
