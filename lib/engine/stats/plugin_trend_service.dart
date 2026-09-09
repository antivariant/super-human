import '../contracts/stats_repository.dart';

enum TrendDirection { up, down, flat }

class PluginTrendPoint {
  PluginTrendPoint({
    required this.day,
    required this.metricValue,
    required this.direction,
  });

  final DateTime day;
  final double metricValue;
  final TrendDirection direction;
}

class PluginTrendService {
  PluginTrendService(this._statsRepository);

  final StatsRepository _statsRepository;

  Future<List<PluginTrendPoint>> getTrend(String pluginId, {int days = 30}) async {
    final List<DailyPluginStats> stats =
        await _statsRepository.listDailyStats(pluginId, days: days);
    final List<PluginTrendPoint> points = <PluginTrendPoint>[];
    double? previous;
    for (final DailyPluginStats current in stats) {
      final double value = current.accuracyRate;
      TrendDirection direction = TrendDirection.flat;
      if (previous != null) {
        if (value > previous) {
          direction = TrendDirection.up;
        } else if (value < previous) {
          direction = TrendDirection.down;
        }
      }
      points.add(PluginTrendPoint(day: current.day, metricValue: value, direction: direction));
      previous = value;
    }
    return points;
  }
}
