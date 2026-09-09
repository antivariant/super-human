import 'package:flutter/material.dart';

import '../../engine/core/plugin_catalog_service.dart';
import '../../plugins/absolute_pitch/application/absolute_pitch_plugin_module.dart';
import '../navigation/app_router.dart';
import '../navigation/training_session_route.dart';
import 'plugin_catalog_view_model.dart';

class PluginCatalogScreen extends StatelessWidget {
  const PluginCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PluginCatalogViewModel viewModel = PluginCatalogViewModel(
      PluginCatalogService(<AbsolutePitchPluginModule>[AbsolutePitchPluginModule()]),
    );
    final modules = viewModel.listPlugins();

    return Scaffold(
      appBar: AppBar(title: const Text('Training Plugins')),
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (BuildContext context, int index) {
          final module = modules[index];
          return ListTile(
            title: Text(module.displayName),
            subtitle: Text('Result: ${module.resultType}'),
            onTap: () {
              Navigator.of(context).push(TrainingSessionRoute.forPlugin(module.pluginId));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRouter.dashboardRoute),
        child: const Icon(Icons.dashboard),
      ),
    );
  }
}
