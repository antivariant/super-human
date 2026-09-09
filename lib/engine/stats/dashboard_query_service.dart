import '../contracts/training_module.dart';
import 'plugin_trend_service.dart';

class PluginDashboardItem {
  PluginDashboardItem({
    required this.pluginId,
    required this.pluginName,
    required this.latestAccuracy,
    required this.direction,
  });

  final String pluginId;
  final String pluginName;
  final double latestAccuracy;
  final TrendDirection direction;
}

class DashboardQueryService {
  DashboardQueryService(this._trendService);

  final PluginTrendService _trendService;

  Future<List<PluginDashboardItem>> buildDashboard(
      List<TrainingModule> modules) async {
    final List<PluginDashboardItem> items = <PluginDashboardItem>[];
    for (final TrainingModule module in modules) {
      final List<PluginTrendPoint> trend =
          await _trendService.getTrend(module.pluginId, days: 30);
      final PluginTrendPoint? latest = trend.isEmpty ? null : trend.last;
      items.add(PluginDashboardItem(
        pluginId: module.pluginId,
        pluginName: module.displayName,
        latestAccuracy: latest?.metricValue ?? 0,
        direction: latest?.direction ?? TrendDirection.flat,
      ));
    }
    return items;
  }
}
