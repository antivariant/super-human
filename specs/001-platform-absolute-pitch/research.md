# Phase 0 Research: Plugin-Based Training Platform with Absolute Pitch MVP

## Decision 1: Core architecture boundary

- Decision: Use layered modules with `engine core -> plugin domain -> UI/infrastructure adapters`, where engine and plugin domain are independent from UI frameworks and cloud services.
- Rationale: Satisfies Constitution requirements for engine independence, plugin isolation, and testability while supporting future plugins with minimal coupling.
- Alternatives considered:
  - Feature logic inside Flutter widgets: rejected due to weak testability and direct UI coupling.
  - Plugin logic writing directly to storage: rejected because it violates plugin isolation.

## Decision 2: Absolute Pitch attempt lifecycle with replay

- Decision: Model an attempt as `note_playing -> answer_open -> answered -> locked_for_next_note`, with replay available only in `answer_open` and replaying the same current note.
- Rationale: Enforces hidden-keyboard timing, one-guess policy, unlimited answer time, replay semantics, and 10-minute lock after submission.
- Alternatives considered:
  - Replay generates a new note: rejected because replay must keep current note.
  - Replay available after submission: rejected because it conflicts with one-guess-per-note closure.

## Decision 3: Deterministic note generation

- Decision: Generate notes using a seed-controlled pseudo-random sequence and store the seed per session.
- Rationale: Preserves deterministic behavior for replayable tests and consistent validation across devices.
- Alternatives considered:
  - System random without seed persistence: rejected because it is not reproducible.
  - Prebaked static note lists only: rejected due to low variability for training.

## Decision 4: Cooldown and anti-bypass handling

- Decision: Persist submission timestamps and cooldown expiry markers in local storage, and evaluate eligibility with consistent cooldown checks before session start and next-note/repeat actions.
- Rationale: Ensures plugin-specific cooldown enforcement and supports edge-case handling when device clock changes.
- Alternatives considered:
  - UI-only lock timer: rejected because it can be bypassed.
  - Server-validated cooldown: rejected because active training must remain offline-first.

## Decision 5: Dashboard metrics strategy

- Decision: Store plugin-native session outcomes and compute daily trend points per plugin; never aggregate into unified cross-plugin score.
- Rationale: Matches product intent (personal improvement without cross-plugin competition) and supports plugin-specific performance semantics.
- Alternatives considered:
  - Unified score normalization across plugins: rejected by explicit scope and requirements.
  - Cumulative totals only: rejected because dashboard must emphasize daily change.

## Decision 6: Contract style for planning artifacts

- Decision: Define internal service contracts using OpenAPI-style endpoints for catalog, session, attempt submission, replay current note, cooldown checks, and dashboard trend retrieval.
- Rationale: Provides clear, testable action contracts for implementation planning while staying transport-agnostic.
- Alternatives considered:
  - No contract artifact: rejected because Phase 1 requires explicit contracts.
  - GraphQL schema first: deferred; REST-style endpoint mapping is sufficient for MVP planning.
