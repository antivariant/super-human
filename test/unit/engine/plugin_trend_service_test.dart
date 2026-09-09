import 'package:test/test.dart';

import 'package:superhuman/engine/contracts/stats_repository.dart';
import 'package:superhuman/engine/stats/plugin_trend_service.dart';
import 'package:superhuman/infrastructure/local_storage/stats_repository_sqlite.dart';

void main() {
  test('calculates trend direction per plugin without cross-plugin aggregation', () async {
    final StatsRepository repo = StatsRepositorySQLite();
    final PluginTrendService service = PluginTrendService(repo);

    await repo.upsertDailyStats(DailyPluginStats(
      pluginId: 'absolute_pitch',
      day: DateTime.utc(2026, 2, 10),
      attemptCount: 10,
      correctCount: 4,
    ));
    await repo.upsertDailyStats(DailyPluginStats(
      pluginId: 'absolute_pitch',
      day: DateTime.utc(2026, 2, 11),
      attemptCount: 10,
      correctCount: 6,
    ));

    final trend = await service.getTrend('absolute_pitch');

    expect(trend.length, 2);
    expect(trend.last.direction, TrendDirection.up);
  });
}
