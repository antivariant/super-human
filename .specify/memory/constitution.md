# SuperHuman Engine Constitution

## Core Principles

### 1. Offline-First (Non-Negotiable)

All training functionality operates fully offline.

Active training sessions never perform network calls.

Cloud services are used only for:
- User authentication
- Progress synchronization
- Optional encrypted backup

The system remains usable without internet access.

---

### 2. Engine-Core Independence

The Core Engine is independent from:
- UI implementations
- Platform-specific APIs
- Cloud services
- Concrete plugin implementations

The Core defines:
- Training lifecycle
- Session orchestration
- Difficulty adjustment
- Skill progression model
- Plugin contract

Outer layers depend on the Core.
The Core does not depend on outer layers.

---

### 3. UI Layer Separation

The system contains two conceptual UI layers:

1. Application UI  
   Responsible for global navigation and system-level interaction.

2. Training UI  
   A plugin-specific interaction surface.

Rules:

- The Core Engine is UI-agnostic.
- Plugin logic does not depend on Application UI.
- Training UI depends only on Plugin logic and Engine APIs.
- Application UI does not contain training-specific logic.
- UI changes do not require Core Engine modifications.

---

### 4. Plugin Isolation

Training modules are implemented as plugins.

Plugins:

- Implement a unified TrainingModule interface.
- Do not directly access local storage.
- Do not directly access cloud services.
- Do not perform network I/O.
- Do not depend on UI implementations.
- Interact only through Engine APIs.

The Plugin API is versioned and stable.

The Engine is open-source.
Plugins may be open or proprietary.

---

### 5. Deterministic Training Logic

Training logic is deterministic and testable.

Given identical seed and input, the system produces identical output.

Randomness is seed-controlled.

Scoring logic is reproducible.

Determinism ensures:
- Fair progression
- Reliable testing
- Safe synchronization
- Cross-device consistency

---

### 6. Performance & Real-Time Constraints

The system targets real-time cognitive training.

Session response latency remains under 50ms.

Audio processing is local.

Active sessions contain no blocking operations.

Heavy memory allocations are avoided inside session loops.

Performance regressions are treated as critical issues.

---

## Technology Baseline

- Core language: Dart
- UI framework: Flutter (single cross-platform codebase)
- Local storage: SQLite
- Cloud services: Authentication and synchronization only
- No web client planned
- Audio processing is local
- Speech recognition is local or OS-native
- Text-to-Speech is local or OS-native

Technology changes require amendment of this Constitution.

---

## Testing & Quality

- The Core Engine is fully testable without UI.
- Plugin logic includes unit tests.
- Deterministic behavior is verifiable.
- Business logic is isolated from infrastructure.
- Sync logic is isolated from training logic.

---

## Governance

This Constitution defines architectural and technological boundaries.

All specifications, plans, and implementations comply with it.

Amendments require:
- Version increment
- Written justification
- Backward compatibility analysis

This Constitution supersedes other development practices.
