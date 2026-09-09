import '../contracts/training_module.dart';

class PluginCatalogService {
  PluginCatalogService(List<TrainingModule> modules)
      : _modules = <String, TrainingModule>{
          for (final TrainingModule module in modules) module.pluginId: module
        };

  final Map<String, TrainingModule> _modules;

  List<TrainingModule> list() => _modules.values.toList(growable: false);

  TrainingModule? byId(String pluginId) => _modules[pluginId];
}
