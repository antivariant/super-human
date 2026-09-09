import '../contracts/cooldown_repository.dart';

class PluginCooldownService {
  PluginCooldownService(this._repository);

  final CooldownRepository _repository;

  Future<bool> canStartSession(String pluginId, DateTime now) async {
    final CooldownRecord? record = await _repository.findByPluginId(pluginId);
    if (record == null || record.lastCompletedSessionAt == null) {
      return true;
    }
    return !now.isBefore(record.sessionNextAllowedAt!);
  }

  Future<DateTime?> nextAllowedAt(String pluginId) async {
    final CooldownRecord? record = await _repository.findByPluginId(pluginId);
    return record?.sessionNextAllowedAt;
  }

  Future<void> recordCompletedSession({
    required String pluginId,
    required int cooldownMinutes,
    required DateTime completedAt,
  }) {
    return _repository.save(CooldownRecord(
      pluginId: pluginId,
      cooldownMinutes: cooldownMinutes,
      lastCompletedSessionAt: completedAt,
    ));
  }
}
