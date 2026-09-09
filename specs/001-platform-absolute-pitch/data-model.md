# Data Model: Plugin-Based Training Platform with Absolute Pitch MVP

## 1. TrainingPlugin

- Purpose: Defines a plugin and its independent behavior contract.
- Fields:
  - `pluginId` (string, unique, immutable)
  - `name` (string)
  - `inputModalities` (set: `voice`, `keyboard`, `touch`)
  - `resultType` (enum, e.g. `boolean`)
  - `cooldownMinutes` (integer, nullable; for Absolute Pitch = 10)
  - `isEnabled` (boolean)
- Validation:
  - `pluginId` must be stable across app restarts.
  - `cooldownMinutes` must be `null` or `>= 0`.

## 2. TrainingSession

- Purpose: Represents one launched training run for one plugin.
- Fields:
  - `sessionId` (string, unique)
  - `pluginId` (FK -> TrainingPlugin.pluginId)
  - `startedAt` (datetime)
  - `endedAt` (datetime, nullable)
  - `seed` (string/integer for deterministic generation)
  - `status` (enum: `active`, `completed`, `aborted`)
- Validation:
  - `pluginId` must reference existing plugin.
  - `endedAt` required when `status` is `completed` or `aborted`.

## 3. AbsolutePitchAttempt

- Purpose: Captures one note challenge and one submitted guess.
- Fields:
  - `attemptId` (string, unique)
  - `sessionId` (FK -> TrainingSession.sessionId)
  - `notePrompt` (enum/string note name)
  - `playbackStartedAt` (datetime)
  - `answerOpenedAt` (datetime)
  - `replayCount` (integer, default 0)
  - `lastReplayAt` (datetime, nullable)
  - `submittedAt` (datetime, nullable)
  - `submissionMode` (enum: `voice`, `keyboard`, nullable)
  - `submittedNote` (string, nullable)
  - `isCorrect` (boolean, nullable until submitted)
  - `state` (enum: `note_playing`, `answer_open`, `answered`, `locked_for_next_note`)
  - `nextAllowedAt` (datetime, nullable; set to `submittedAt + 10m` after valid submission)
- Validation:
  - Exactly one valid submission per attempt.
  - Replay is allowed only while `state == answer_open`.
  - Replay must not change `notePrompt`.
  - `submittedAt` cannot be earlier than `answerOpenedAt`.
  - If `state` is `answered` or `locked_for_next_note`, `isCorrect` must be non-null.

## 4. CooldownRecord

- Purpose: Tracks plugin-level lockouts between sessions.
- Fields:
  - `pluginId` (FK -> TrainingPlugin.pluginId)
  - `lastCompletedSessionAt` (datetime)
  - `cooldownMinutes` (integer)
  - `sessionNextAllowedAt` (datetime)
- Validation:
  - `sessionNextAllowedAt` must equal `lastCompletedSessionAt + cooldownMinutes`.

## 5. PluginStatsDaily

- Purpose: Stores per-plugin per-day trend points for dashboard.
- Fields:
  - `pluginId` (FK -> TrainingPlugin.pluginId)
  - `day` (date)
  - `attemptCount` (integer)
  - `correctCount` (integer)
  - `accuracyRate` (decimal)
  - `trendDirection` (enum: `up`, `down`, `flat`)
- Validation:
  - `0 <= correctCount <= attemptCount`.
  - `accuracyRate` derived from counts using plugin-specific logic.

## Relationships

- `TrainingPlugin` 1-to-many `TrainingSession`
- `TrainingSession` 1-to-many `AbsolutePitchAttempt`
- `TrainingPlugin` 1-to-one `CooldownRecord` (when cooldown configured)
- `TrainingPlugin` 1-to-many `PluginStatsDaily`

## State Transitions

### AbsolutePitchAttempt

- `note_playing` -> `answer_open`: note playback finished, keyboard visible.
- `answer_open` -> `answer_open` (replay): replay current note, increment `replayCount`, keep same `notePrompt`.
- `answer_open` -> `answered`: first valid submission accepted.
- `answered` -> `locked_for_next_note`: lock set until `nextAllowedAt`.
- `locked_for_next_note` -> `note_playing` (next attempt): only when current time >= `nextAllowedAt`.

### TrainingSession

- `active` -> `completed`: learner ends flow after valid attempt cycle(s).
- `active` -> `aborted`: learner exits before completion.
