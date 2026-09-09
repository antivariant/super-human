class TrainingSessionRecord {
  TrainingSessionRecord({
    required this.sessionId,
    required this.pluginId,
    required this.startedAt,
    this.endedAt,
    required this.seed,
    required this.status,
  });

  final String sessionId;
  final String pluginId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int seed;
  final String status;
}

abstract class SessionRepository {
  Future<void> saveSession(TrainingSessionRecord session);
  Future<TrainingSessionRecord?> findById(String sessionId);
  Future<List<TrainingSessionRecord>> listByPlugin(String pluginId);
}
