# Tasks: Plugin-Based Training Platform with Absolute Pitch MVP

**Input**: Design documents from `/specs/001-platform-absolute-pitch/`
**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/training-api.openapi.yaml`

**Tests**: Included due to constitution and plan requirements for deterministic engine/plugin behavior and integration verification.

**Organization**: Tasks are grouped by user story so each story remains independently implementable and testable.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on incomplete tasks)
- **[Story]**: User story label (`[US1]`, `[US2]`, `[US3]`)
- Every task includes explicit file path(s)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Initialize project structure and baseline tooling.

- [X] T001 Create module directory skeleton in `lib/app/`, `lib/engine/`, `lib/plugins/absolute_pitch/`, `lib/infrastructure/`, `test/`
- [X] T002 Add Flutter and test dependencies for plan stack in `pubspec.yaml`
- [X] T003 [P] Configure static analysis and lint rules in `analysis_options.yaml`
- [X] T004 [P] Bootstrap app entrypoint and root router shell in `lib/main.dart` and `lib/app/navigation/app_router.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core contracts and infrastructure required by all user stories.

**⚠️ CRITICAL**: No user story implementation starts before this phase is complete.

- [X] T005 Define plugin contract interface in `lib/engine/contracts/training_module.dart`
- [X] T006 Define engine repository/service interfaces in `lib/engine/contracts/session_repository.dart`, `lib/engine/contracts/cooldown_repository.dart`, and `lib/engine/contracts/stats_repository.dart`
- [X] T007 [P] Implement SQLite schema and migration bootstrap in `lib/infrastructure/local_storage/sqlite_schema.dart`
- [X] T008 [P] Implement session and attempt SQLite repositories in `lib/infrastructure/local_storage/session_repository_sqlite.dart` and `lib/infrastructure/local_storage/absolute_pitch_attempt_repository_sqlite.dart`
- [X] T009 [P] Implement cooldown and stats SQLite repositories in `lib/infrastructure/local_storage/cooldown_repository_sqlite.dart` and `lib/infrastructure/local_storage/stats_repository_sqlite.dart`
- [X] T010 Implement deterministic note generation service in `lib/engine/core/deterministic_note_generator.dart`
- [X] T011 Implement training session orchestrator and plugin dispatch in `lib/engine/sessions/training_session_orchestrator.dart`
- [X] T012 Implement plugin catalog registration service in `lib/engine/core/plugin_catalog_service.dart`
- [X] T013 Implement cooldown eligibility core service in `lib/engine/cooldown/plugin_cooldown_service.dart`
- [X] T014 [P] Add foundational unit tests for deterministic generation and orchestration in `test/unit/engine/deterministic_note_generator_test.dart` and `test/unit/engine/training_session_orchestrator_test.dart`

**Checkpoint**: Foundation ready; user stories can begin.

---

## Phase 3: User Story 1 - Complete Absolute Pitch Session (Priority: P1) 🎯 MVP

**Goal**: Deliver complete Absolute Pitch training loop with one guess per note, unlimited answer time, boolean result, and 10-minute lock for next note/repeat.

**Independent Test**: Launch Absolute Pitch, complete one attempt through playback -> answer -> result persistence, verify second guess rejection and 10-minute lock behavior.

### Tests for User Story 1

- [X] T015 [P] [US1] Add contract test for attempt submission and single-guess rejection in `test/contract/plugin_api/absolute_pitch_attempt_contract_test.dart`
- [X] T016 [P] [US1] Add integration test for playback visibility, submission, persistence, and lock timing in `test/integration/session_flow/absolute_pitch_session_flow_test.dart`

### Implementation for User Story 1

- [X] T017 [P] [US1] Implement attempt domain state machine in `lib/plugins/absolute_pitch/domain/absolute_pitch_attempt.dart`
- [X] T018 [P] [US1] Implement note prompt generator policy in `lib/plugins/absolute_pitch/domain/absolute_pitch_note_sequence.dart`
- [X] T019 [US1] Implement Absolute Pitch session application service in `lib/plugins/absolute_pitch/application/absolute_pitch_session_service.dart`
- [X] T020 [US1] Implement single-submission guard logic in `lib/plugins/absolute_pitch/application/attempt_submission_guard.dart`
- [X] T021 [US1] Implement next-note/repeat 10-minute lock service in `lib/plugins/absolute_pitch/application/next_note_lock_service.dart`
- [X] T022 [US1] Implement training screen with keyboard hidden during playback in `lib/plugins/absolute_pitch/training_ui/absolute_pitch_training_screen.dart`
- [X] T023 [P] [US1] Implement keyboard and voice answer input adapters in `lib/plugins/absolute_pitch/training_ui/piano_keyboard_input.dart` and `lib/infrastructure/speech/note_recognition_adapter.dart`
- [X] T024 [US1] Persist attempt results and lock timestamps in `lib/infrastructure/local_storage/absolute_pitch_attempt_repository_sqlite.dart`
- [X] T025 [US1] Wire training route from app shell to Absolute Pitch screen in `lib/app/navigation/training_session_route.dart`
- [X] T026 [US1] Add unit tests for unlimited-time answer and one-guess enforcement in `test/unit/plugins/absolute_pitch/absolute_pitch_session_service_test.dart`

**Checkpoint**: User Story 1 is independently functional and testable (MVP).

---

## Phase 4: User Story 2 - Use Plugin Catalog and Cooldown Rules (Priority: P2)

**Goal**: Let users browse plugin catalog, start available plugins, and block early restarts with clear availability messaging.

**Independent Test**: Complete a plugin session, attempt immediate restart, verify block and retry-at information, then verify access after cooldown expiry.

### Tests for User Story 2

- [X] T027 [P] [US2] Add contract test for plugin list and cooldown status endpoints in `test/contract/plugin_api/plugin_catalog_cooldown_contract_test.dart`
- [X] T028 [P] [US2] Add integration test for catalog launch and cooldown block flow in `test/integration/session_flow/plugin_catalog_cooldown_test.dart`

### Implementation for User Story 2

- [X] T029 [US2] Implement catalog view model and state mapping in `lib/app/plugin_catalog/plugin_catalog_view_model.dart`
- [X] T030 [US2] Implement plugin catalog screen and launch actions in `lib/app/plugin_catalog/plugin_catalog_screen.dart`
- [X] T031 [US2] Implement session-start guard and retry-at messaging in `lib/app/plugin_catalog/plugin_launch_guard.dart`
- [X] T032 [US2] Extend cooldown service for plugin-level session gating in `lib/engine/cooldown/plugin_cooldown_service.dart`
- [X] T033 [US2] Add cooldown edge-case tests (clock changes, lock boundaries) in `test/unit/engine/plugin_cooldown_service_test.dart`

**Checkpoint**: User Story 2 is independently functional and testable.

---

## Phase 5: User Story 3 - Track Progress by Plugin Over Time (Priority: P3)

**Goal**: Display per-plugin dashboard statistics and daily trends without cross-plugin score aggregation.

**Independent Test**: Populate multi-day plugin results, open dashboard, verify per-plugin trend direction and absence of unified scoring.

### Tests for User Story 3

- [X] T034 [P] [US3] Add contract test for dashboard summary and trends endpoints in `test/contract/plugin_api/dashboard_contract_test.dart`
- [X] T035 [P] [US3] Add integration test for daily trend visualization and plugin separation in `test/integration/dashboard/plugin_trends_dashboard_test.dart`

### Implementation for User Story 3

- [X] T036 [US3] Implement daily per-plugin trend aggregation service in `lib/engine/stats/plugin_trend_service.dart`
- [X] T037 [US3] Implement dashboard query service and DTO mapping in `lib/engine/stats/dashboard_query_service.dart`
- [X] T038 [US3] Implement dashboard screen with per-plugin cards in `lib/app/dashboard/dashboard_screen.dart`
- [X] T039 [US3] Implement trend card widget with empty-state and direction rendering in `lib/app/dashboard/plugin_trend_card.dart`
- [X] T040 [US3] Add unit tests for trend calculations and no cross-plugin aggregation in `test/unit/engine/plugin_trend_service_test.dart`

**Checkpoint**: User Story 3 is independently functional and testable.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final hardening and validation across all stories.

- [X] T041 [P] Update executable validation steps for delivered behavior in `specs/001-platform-absolute-pitch/quickstart.md`
- [X] T042 [P] Sync implemented behavior with API planning contract in `specs/001-platform-absolute-pitch/contracts/training-api.openapi.yaml`
- [X] T043 Run full test matrix and capture outcomes in `specs/001-platform-absolute-pitch/implementation-validation.md`
- [X] T044 Capture session-latency profiling against <50ms target in `specs/001-platform-absolute-pitch/performance-report.md`
- [X] T045 Define internal service contract adapter (non-HTTP) aligned to planning contract in `lib/engine/contracts/training_api_contract.dart`
- [X] T046 [P] Add negative test coverage for excluded multiplayer/leaderboards/cross-user flows in `test/integration/session_flow/out_of_scope_guards_test.dart`
- [X] T047 [P] Add emulator test run profiles for iOS and Android development validation in `tool/emulator-test-matrix.md`
- [X] T048 Run iPhone and Android emulator validation and store evidence in `specs/001-platform-absolute-pitch/emulator-validation.md`
- [X] T049 Produce constitution compliance verification checklist and results in `specs/001-platform-absolute-pitch/constitution-compliance.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: starts immediately.
- **Phase 2 (Foundational)**: depends on Phase 1; blocks all user stories.
- **Phase 3 (US1)**: depends on Phase 2; defines MVP.
- **Phase 4 (US2)**: depends on Phase 2; can proceed after US1 starts, but recommended after US1 checkpoint.
- **Phase 5 (US3)**: depends on Phase 2 and availability of persisted session data contracts.
- **Phase 6 (Polish)**: depends on completion of all targeted stories.
- **Phase 6 (Polish)**: must include contract-alignment, emulator validation, and constitution compliance outputs before sign-off.

### User Story Dependencies

- **US1 (P1)**: no dependency on other user stories.
- **US2 (P2)**: depends on foundational cooldown and catalog services, independent of US3.
- **US3 (P3)**: depends on foundational stats and storage contracts; consumes outputs from session persistence.

### Within Each User Story

- Tests before implementation tasks.
- Domain/model logic before application services.
- Application services before UI wiring.
- Story-level unit/integration pass required before moving to polish.

### Parallel Opportunities

- Setup: T003 and T004 can run in parallel after T002 starts.
- Foundational: T007/T008/T009 parallel; T014 parallel once T010 and T011 are ready.
- US1: T015/T016 and T017/T018/T023 parallel tracks.
- US2: T027/T028 parallel; T029 and T032 can progress in parallel.
- US3: T034/T035 parallel; T038 and T039 split once T037 contract is stable.
- Polish: T046 and T047 can run in parallel before T048/T049 sign-off tasks.

---

## Parallel Example: User Story 1

```bash
Task: "T015 [US1] Contract test in test/contract/plugin_api/absolute_pitch_attempt_contract_test.dart"
Task: "T016 [US1] Integration test in test/integration/session_flow/absolute_pitch_session_flow_test.dart"
Task: "T017 [US1] State machine in lib/plugins/absolute_pitch/domain/absolute_pitch_attempt.dart"
Task: "T018 [US1] Note sequence policy in lib/plugins/absolute_pitch/domain/absolute_pitch_note_sequence.dart"
```

## Parallel Example: User Story 2

```bash
Task: "T027 [US2] Contract test in test/contract/plugin_api/plugin_catalog_cooldown_contract_test.dart"
Task: "T028 [US2] Integration test in test/integration/session_flow/plugin_catalog_cooldown_test.dart"
Task: "T029 [US2] View model in lib/app/plugin_catalog/plugin_catalog_view_model.dart"
Task: "T032 [US2] Cooldown service extension in lib/engine/cooldown/plugin_cooldown_service.dart"
```

## Parallel Example: User Story 3

```bash
Task: "T034 [US3] Contract test in test/contract/plugin_api/dashboard_contract_test.dart"
Task: "T035 [US3] Integration test in test/integration/dashboard/plugin_trends_dashboard_test.dart"
Task: "T038 [US3] Dashboard screen in lib/app/dashboard/dashboard_screen.dart"
Task: "T039 [US3] Trend card widget in lib/app/dashboard/plugin_trend_card.dart"
```

---

## Implementation Strategy

### MVP First (US1 only)

1. Finish Phase 1 and Phase 2.
2. Deliver Phase 3 (US1) fully.
3. Validate quickstart steps for Absolute Pitch core flow.
4. Demo/deploy MVP increment.

### Incremental Delivery

1. US1: working Absolute Pitch loop with one-guess + 10-minute lock.
2. US2: catalog and cooldown-aware launch flow.
3. US3: per-plugin trend dashboard.
4. Phase 6: finalize quality gates, profiling, and documentation.

### Parallel Team Strategy

1. Team aligns on Phase 1-2.
2. After foundational checkpoint:
   - Engineer A: US1 application + UI loop
   - Engineer B: US2 catalog and cooldown UX
   - Engineer C: US3 stats + dashboard
3. Merge behind contract tests and integration gates.

---

## Notes

- `[P]` tasks target disjoint files and can run concurrently.
- `[USx]` labels provide strict traceability from spec to implementation.
- Each story is designed to be demonstrable independently.
- Commit by logical task groups and validate at each story checkpoint.
