# Implementation Plan: Plugin-Based Training Platform with Absolute Pitch MVP

**Branch**: `001-platform-absolute-pitch` | **Date**: 2026-02-13 | **Spec**: `/Users/antivariant/Documents/Business/SuperHuman/specs/001-platform-absolute-pitch/spec.md`
**Input**: Feature specification from `/specs/001-platform-absolute-pitch/spec.md`

## Summary

Build the SuperHuman training foundation as an offline-first, plugin-based Flutter application with an engine core independent from UI and infrastructure. Deliver Absolute Pitch as the first plugin with one-guess attempts, unlimited answer time, replay of the current note before submission, and a mandatory 10-minute wait before requesting the next random note or repeat test after submission. Persist results locally, enforce plugin cooldown policies, and expose per-plugin trend dashboards without cross-plugin score aggregation.

## Technical Context

**Language/Version**: Dart 3.x  
**Primary Dependencies**: Flutter SDK, package:test, flutter_test, integration_test, sqlite-backed persistence library  
**Storage**: SQLite (local-only for active training and statistics)  
**Testing**: package:test (core + plugin logic), flutter_test (UI boundaries), integration_test (end-to-end session and dashboard flows)  
**Target Platform**: Native macOS app runtime; iPhone and Android emulators for development testing  
**Project Type**: Mobile/Desktop application (single Flutter codebase with separable engine, plugin, and app UI modules)  
**Performance Goals**: Session interaction response under 50ms; replay action response under 50ms in active session  
**Constraints**: Offline-first sessions, deterministic scoring/note generation with seed control, replay allowed only for current note before submission, one submitted guess per note, 10-minute lock before next note/retest, no unified cross-plugin scoring, no web client  
**Scale/Scope**: MVP with Absolute Pitch plus plugin framework for subsequent modules; single-user local training history and per-plugin trend visualization

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- `Offline-First`: PASS. Session flow, replay action, evaluation, and cooldown enforcement remain local with no network dependency.
- `Engine-Core Independence`: PASS. Replay behavior is represented in plugin domain/application services, not in app shell.
- `UI Layer Separation`: PASS. Replay control belongs to training UI; app navigation remains training-agnostic.
- `Plugin Isolation`: PASS. Plugin replay logic interacts via engine APIs/contracts only.
- `Deterministic Training Logic`: PASS. Replay replays current note without regenerating prompt; seeded note sequence remains deterministic.
- `Performance & Real-Time Constraints`: PASS. Replay and answer path stay non-blocking.
- `Technology Baseline`: PASS. Dart + Flutter + SQLite preserved; no web target introduced.
- `Testing & Quality`: PASS. Unit/contract/integration coverage includes replay semantics and one-guess invariants.

No constitution violations identified.

### Post-Design Re-Check (After Phase 1 Artifacts)

- `research.md`, `data-model.md`, `contracts/training-api.openapi.yaml`, and `quickstart.md` preserve Offline-First, Plugin Isolation, and Engine-Core Independence constraints.
- Replay contract and data model additions do not introduce cloud dependencies.
- No artifact introduces cross-plugin score aggregation.
- Re-check result: PASS.

## Project Structure

### Documentation (this feature)

```text
specs/001-platform-absolute-pitch/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── training-api.openapi.yaml
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app/
│   ├── navigation/
│   ├── dashboard/
│   └── plugin_catalog/
├── engine/
│   ├── core/
│   ├── sessions/
│   ├── cooldown/
│   ├── stats/
│   └── contracts/
├── plugins/
│   └── absolute_pitch/
│       ├── domain/
│       ├── application/
│       └── training_ui/
└── infrastructure/
    ├── local_storage/
    ├── audio/
    └── speech/

test/
├── unit/
│   ├── engine/
│   └── plugins/
├── integration/
│   ├── session_flow/
│   └── dashboard/
└── contract/
    └── plugin_api/
```

**Structure Decision**: Single Flutter codebase with strict module boundaries by responsibility. Engine core and plugin domain remain framework-light and test-first; infrastructure adapters and UI depend inward on engine contracts.

## Complexity Tracking

No constitution violations or exceptional complexity exemptions required.
