import 'package:flutter/material.dart';

import '../../engine/stats/dashboard_query_service.dart';
import '../../engine/stats/plugin_trend_service.dart';

class PluginTrendCard extends StatelessWidget {
  const PluginTrendCard({super.key, required this.item});

  final PluginDashboardItem item;

  @override
  Widget build(BuildContext context) {
    final String trendText = switch (item.direction) {
      TrendDirection.up => 'Improving',
      TrendDirection.down => 'Declining',
      TrendDirection.flat => 'Stable',
    };

    return Card(
      child: ListTile(
        title: Text(item.pluginName),
        subtitle: Text('Trend: $trendText'),
        trailing: Text('${(item.latestAccuracy * 100).toStringAsFixed(1)}%'),
      ),
    );
  }
}
