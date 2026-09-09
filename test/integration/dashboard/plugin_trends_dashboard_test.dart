import 'package:test/test.dart';

import 'package:superhuman/engine/contracts/stats_repository.dart';
import 'package:superhuman/engine/stats/dashboard_query_service.dart';
import 'package:superhuman/engine/stats/plugin_trend_service.dart';
import 'package:superhuman/infrastructure/local_storage/stats_repository_sqlite.dart';
import 'package:superhuman/plugins/absolute_pitch/application/absolute_pitch_plugin_module.dart';

void main() {
  test('dashboard trend direction is available per plugin', () async {
    final StatsRepository repo = StatsRepositorySQLite();
    await repo.upsertDailyStats(DailyPluginStats(
      pluginId: 'absolute_pitch',
      day: DateTime.utc(2026, 2, 12),
      attemptCount: 10,
      correctCount: 5,
    ));
    await repo.upsertDailyStats(DailyPluginStats(
      pluginId: 'absolute_pitch',
      day: DateTime.utc(2026, 2, 13),
      attemptCount: 10,
      correctCount: 7,
    ));

    final dashboard = DashboardQueryService(PluginTrendService(repo));
    final items = await dashboard.buildDashboard(<AbsolutePitchPluginModule>[AbsolutePitchPluginModule()]);

    expect(items.single.pluginId, 'absolute_pitch');
    expect(items.single.latestAccuracy, greaterThan(0));
  });
}
