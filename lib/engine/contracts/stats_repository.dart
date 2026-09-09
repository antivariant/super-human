class DailyPluginStats {
  DailyPluginStats({
    required this.pluginId,
    required this.day,
    required this.attemptCount,
    required this.correctCount,
  });

  final String pluginId;
  final DateTime day;
  final int attemptCount;
  final int correctCount;

  double get accuracyRate => attemptCount == 0 ? 0 : correctCount / attemptCount;
}

abstract class StatsRepository {
  Future<void> upsertDailyStats(DailyPluginStats stats);
  Future<List<DailyPluginStats>> listDailyStats(String pluginId, {int days = 30});
}
