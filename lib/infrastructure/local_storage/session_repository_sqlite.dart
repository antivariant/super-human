import '../../engine/contracts/session_repository.dart';

class SessionRepositorySQLite implements SessionRepository {
  final Map<String, TrainingSessionRecord> _store = <String, TrainingSessionRecord>{};

  @override
  Future<TrainingSessionRecord?> findById(String sessionId) async {
    return _store[sessionId];
  }

  @override
  Future<List<TrainingSessionRecord>> listByPlugin(String pluginId) async {
    return _store.values
        .where((TrainingSessionRecord it) => it.pluginId == pluginId)
        .toList(growable: false);
  }

  @override
  Future<void> saveSession(TrainingSessionRecord session) async {
    _store[session.sessionId] = session;
  }
}
