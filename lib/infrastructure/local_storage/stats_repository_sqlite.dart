import '../../engine/contracts/stats_repository.dart';

class StatsRepositorySQLite implements StatsRepository {
  final Map<String, List<DailyPluginStats>> _statsByPlugin =
      <String, List<DailyPluginStats>>{};

  @override
  Future<List<DailyPluginStats>> listDailyStats(String pluginId,
      {int days = 30}) async {
    final List<DailyPluginStats> all =
        _statsByPlugin[pluginId]?.toList(growable: false) ?? <DailyPluginStats>[];
    all.sort((DailyPluginStats a, DailyPluginStats b) => a.day.compareTo(b.day));
    return all.length <= days ? all : all.sublist(all.length - days);
  }

  @override
  Future<void> upsertDailyStats(DailyPluginStats stats) async {
    final List<DailyPluginStats> list =
        _statsByPlugin.putIfAbsent(stats.pluginId, () => <DailyPluginStats>[]);
    final int existingIndex =
        list.indexWhere((DailyPluginStats it) => _isSameDay(it.day, stats.day));
    if (existingIndex >= 0) {
      list[existingIndex] = stats;
    } else {
      list.add(stats);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
