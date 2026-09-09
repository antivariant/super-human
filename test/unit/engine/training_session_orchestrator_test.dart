import 'package:test/test.dart';

import 'package:superhuman/engine/sessions/training_session_orchestrator.dart';
import 'package:superhuman/infrastructure/local_storage/session_repository_sqlite.dart';

void main() {
  test('startSession persists active record', () async {
    final SessionRepositorySQLite repo = SessionRepositorySQLite();
    final TrainingSessionOrchestrator orchestrator = TrainingSessionOrchestrator(repo);

    final session = await orchestrator.startSession(
      sessionId: 's1',
      pluginId: 'absolute_pitch',
      seed: 42,
    );

    expect(session.status, 'active');
    final stored = await repo.findById('s1');
    expect(stored?.pluginId, 'absolute_pitch');
  });
}
