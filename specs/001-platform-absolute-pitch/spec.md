# Feature Specification: Plugin-Based Training Platform with Absolute Pitch MVP

**Feature Branch**: `001-platform-absolute-pitch`  
**Created**: 2026-02-13  
**Status**: Draft  
**Input**: User description: "SuperHuman cross-platform cognitive training platform with plugin-based architecture, global dashboard, and Absolute Pitch as first plugin."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Complete Absolute Pitch Session (Priority: P1)

A learner selects the Absolute Pitch training plugin, listens to a played note, and submits an answer by clicking a piano key or saying the note name.

**Why this priority**: This is the core user value for the initial release. Without a fully working training session, the product does not provide its primary benefit.

**Independent Test**: Can be fully tested by running a full session from plugin selection to result recording and confirming a correct or incorrect outcome is saved.

**Acceptance Scenarios**:

1. **Given** the learner opens the app and selects Absolute Pitch, **When** the session starts, **Then** a note is played and the piano keyboard remains hidden during playback.
2. **Given** the note playback has ended, **When** the learner views the training interface, **Then** the piano keyboard becomes visible and answer input is enabled.
3. **Given** an active Absolute Pitch attempt, **When** the learner submits either a key click or a voice note name, **Then** the attempt is evaluated as correct or incorrect only.
4. **Given** an attempt is evaluated, **When** the session result is finalized, **Then** the boolean result is stored in local session history for the Absolute Pitch plugin.
5. **Given** the learner has submitted an answer for the current note, **When** they request a next random note or an immediate repeat, **Then** the system blocks it until at least 10 minutes have passed.
6. **Given** the learner is on the current Absolute Pitch note before submitting an answer, **When** they press the replay button, **Then** the same current note is played again without generating a new note.

---

### User Story 2 - Use Plugin Catalog and Cooldown Rules (Priority: P2)

A learner can browse available plugins, start a permitted plugin session, and is blocked from restarting a plugin when a configured cooldown is still active.

**Why this priority**: Plugin independence and cooldown enforcement are essential to the platform model and prevent invalid repeated practice.

**Independent Test**: Can be tested by configuring at least one plugin with cooldown, finishing a session, attempting immediate restart, and confirming the block with retry availability after cooldown ends.

**Acceptance Scenarios**:

1. **Given** plugins are available, **When** the learner opens the plugin list, **Then** each plugin is shown as an independent training option.
2. **Given** a plugin has an active cooldown, **When** the learner tries to start it early, **Then** session start is blocked and the learner is informed when it will be available.
3. **Given** the cooldown period has passed, **When** the learner starts the same plugin, **Then** a new session starts successfully.

---

### User Story 3 - Track Progress by Plugin Over Time (Priority: P3)

A learner opens a global dashboard to review progress trends per plugin and understand improvement or decline by day.

**Why this priority**: Long-term personal improvement requires clear trend visibility, but can be delivered after core training flow.

**Independent Test**: Can be tested by completing sessions across multiple days and plugins, then verifying dashboard trend displays per plugin without cross-plugin score merging.

**Acceptance Scenarios**:

1. **Given** the learner has completed sessions for one or more plugins, **When** the dashboard is opened, **Then** statistics are displayed separately for each plugin.
2. **Given** historical session data exists, **When** trend views are displayed, **Then** daily change (improvement or decline) is shown instead of cumulative-only totals.
3. **Given** plugins use different scoring formats, **When** dashboard data is presented, **Then** each plugin's own performance metrics are shown without unified cross-plugin ranking.

### Edge Cases

- A learner closes the app during an active session: partial attempts are not recorded as completed session results.
- A voice answer is empty or unintelligible: the system does not submit an attempt and prompts for a valid note name; after a valid submission, no second guess is allowed for that note.
- The learner provides both voice and keyboard input for the same attempt: only the first accepted input is evaluated and stored.
- A plugin has no completed sessions yet: dashboard shows an explicit empty-state message for that plugin.
- Device local clock changes after session completion: cooldown eligibility is computed consistently so cooldown cannot be bypassed by manual clock manipulation.
- Replay is pressed after the attempt has already been submitted: replay of the previous note is disabled and the user must wait for the next allowed note window.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST allow the learner to launch the native desktop app and access available training plugins.
- **FR-002**: The system MUST maintain plugins as independent modules with isolated training logic, scoring logic, and statistics.
- **FR-003**: The system MUST allow the learner to start a session for a selected plugin when no active cooldown prevents it.
- **FR-004**: The system MUST store completed session results locally on the device.
- **FR-005**: The system MUST enforce plugin-specific cooldown periods between sessions when configured and block early session restarts.
- **FR-006**: The system MUST present a global dashboard with per-plugin statistics only.
- **FR-007**: The system MUST show per-plugin daily trend direction (improvement or decline) over time.
- **FR-008**: The system MUST avoid unified scoring across different plugins and MUST NOT compare plugin scores directly.
- **FR-009**: For Absolute Pitch sessions, the system MUST play one piano note per attempt and hide the piano keyboard during playback.
- **FR-010**: For Absolute Pitch sessions, the system MUST reveal the piano keyboard only after note playback ends.
- **FR-011**: For Absolute Pitch sessions, the system MUST accept answer input by piano key selection or spoken note name.
- **FR-012**: For Absolute Pitch sessions, the system MUST evaluate each attempt as either correct or incorrect only.
- **FR-013**: For Absolute Pitch sessions, the system MUST NOT calculate semitone deviation or singing pitch match.
- **FR-014**: For Absolute Pitch sessions, the learner MUST be allowed unlimited time to submit an answer for the current note.
- **FR-015**: For Absolute Pitch sessions, each played note MUST allow exactly one submitted guess (correct or incorrect), with no second guess for that note.
- **FR-016**: For Absolute Pitch sessions, the next random note and repeat-test action MUST remain unavailable until at least 10 minutes after the submitted guess.
- **FR-020**: For Absolute Pitch sessions, the training UI MUST provide a replay button for the current note.
- **FR-021**: Pressing replay MUST replay the same current note and MUST NOT generate a new random note or reset attempt state.
- **FR-022**: Replay availability MUST preserve one-guess-per-note behavior and MUST be disabled after a valid submission for that note.
- **FR-017**: The system MUST operate without multiplayer, global leaderboards, or cross-user score comparison.
- **FR-018**: The system MUST provide operational support for local development testing on iPhone and Android emulators.
- **FR-019**: The feature implementation MUST comply with the current project Constitution.

### Key Entities *(include if feature involves data)*

- **Training Plugin**: An independent exercise module with its own identity, training rules, scoring model, input modalities, and optional cooldown policy.
- **Training Session**: A single execution instance for one plugin with start/end timestamps, attempt outcomes, and completion status.
- **Plugin Attempt Result**: The outcome record for one attempt within a session, including submission modality and correctness.
- **Plugin Statistics Snapshot**: Aggregated per-plugin performance indicators derived from local session history.
- **Cooldown Policy**: Rules defining required rest interval between completed sessions for a specific plugin.
- **Dashboard Trend Point**: A daily metric value and direction marker (up/down/flat) for one plugin.

### Assumptions

- The first release includes at least one plugin (Absolute Pitch), while the plugin framework must support additional plugins later without changing cross-plugin scoring policy.
- Daily trends are calculated from completed local sessions using each plugin's own metrics.
- If cloud sync is unavailable, training and local history remain fully usable.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of validation tests, Absolute Pitch accepts a first valid answer without any forced answer timeout for the current note.
- **SC-002**: 100% of completed sessions are visible in local history after app restart, with no missing records in validation tests.
- **SC-003**: For plugins with configured cooldown, 100% of early restart attempts are blocked before cooldown expiry in acceptance tests.
- **SC-004**: 100% of dashboard views display plugin metrics separately with no merged cross-plugin score on validation datasets.
- **SC-005**: For historical test data covering at least 7 days, dashboard trend direction is correct for at least 99% of daily points per plugin.
- **SC-006**: In at least 90% of moderated usability runs, participants correctly identify whether their performance improved or declined for a chosen plugin within 30 seconds.
- **SC-007**: In 100% of Absolute Pitch validation cases, a second guess for the same played note is rejected after the first submitted answer.
- **SC-008**: In 100% of Absolute Pitch validation cases, next-random-note and repeat-test actions are unavailable until at least 10 minutes after the submitted guess.
