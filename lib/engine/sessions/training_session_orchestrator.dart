import '../contracts/session_repository.dart';

class TrainingSessionOrchestrator {
  TrainingSessionOrchestrator(this._sessionRepository);

  final SessionRepository _sessionRepository;

  Future<TrainingSessionRecord> startSession({
    required String sessionId,
    required String pluginId,
    required int seed,
    DateTime? startedAt,
  }) async {
    final TrainingSessionRecord record = TrainingSessionRecord(
      sessionId: sessionId,
      pluginId: pluginId,
      startedAt: startedAt ?? DateTime.now().toUtc(),
      seed: seed,
      status: 'active',
    );
    await _sessionRepository.saveSession(record);
    return record;
  }

  Future<TrainingSessionRecord?> getSession(String sessionId) {
    return _sessionRepository.findById(sessionId);
  }
}
