import 'package:flutter/material.dart';

import '../../engine/contracts/training_module.dart';
import '../../engine/core/plugin_catalog_service.dart';
import '../../engine/stats/dashboard_query_service.dart';
import '../../engine/stats/plugin_trend_service.dart';
import '../../infrastructure/local_storage/stats_repository_sqlite.dart';
import '../../plugins/absolute_pitch/application/absolute_pitch_plugin_module.dart';
import 'plugin_trend_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardQueryService _queryService;
  late final List<TrainingModule> _modules;

  @override
  void initState() {
    super.initState();
    _queryService = DashboardQueryService(
      PluginTrendService(StatsRepositorySQLite()),
    );
    _modules = PluginCatalogService(<TrainingModule>[AbsolutePitchPluginModule()]).list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: FutureBuilder<List<PluginDashboardItem>>(
        future: _queryService.buildDashboard(_modules),
        builder: (BuildContext context, AsyncSnapshot<List<PluginDashboardItem>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No plugin stats yet.'));
          }
          return ListView(
            children: items
                .map((PluginDashboardItem item) => PluginTrendCard(item: item))
                .toList(growable: false),
          );
        },
      ),
    );
  }
}
