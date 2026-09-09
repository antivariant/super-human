class CooldownRecord {
  CooldownRecord({
    required this.pluginId,
    required this.cooldownMinutes,
    this.lastCompletedSessionAt,
  });

  final String pluginId;
  final int cooldownMinutes;
  final DateTime? lastCompletedSessionAt;

  DateTime? get sessionNextAllowedAt =>
      lastCompletedSessionAt?.add(Duration(minutes: cooldownMinutes));
}

abstract class CooldownRepository {
  Future<void> save(CooldownRecord record);
  Future<CooldownRecord?> findByPluginId(String pluginId);
}
