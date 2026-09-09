import 'package:test/test.dart';

import 'package:superhuman/engine/contracts/stats_repository.dart';
import 'package:superhuman/engine/stats/dashboard_query_service.dart';
import 'package:superhuman/engine/stats/plugin_trend_service.dart';
import 'package:superhuman/infrastructure/local_storage/stats_repository_sqlite.dart';
import 'package:superhuman/plugins/absolute_pitch/application/absolute_pitch_plugin_module.dart';

void main() {
  test('dashboard returns per-plugin item without cross-plugin merge', () async {
    final StatsRepository repo = StatsRepositorySQLite();
    await repo.upsertDailyStats(DailyPluginStats(
      pluginId: 'absolute_pitch',
      day: DateTime.utc(2026, 2, 13),
      attemptCount: 10,
      correctCount: 8,
    ));

    final query = DashboardQueryService(PluginTrendService(repo));
    final items = await query.buildDashboard(<AbsolutePitchPluginModule>[AbsolutePitchPluginModule()]);

    expect(items.length, 1);
    expect(items.single.pluginId, 'absolute_pitch');
  });
}
