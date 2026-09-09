import '../../engine/contracts/training_module.dart';
import '../../engine/core/plugin_catalog_service.dart';

class PluginCatalogViewModel {
  PluginCatalogViewModel(this._catalogService);

  final PluginCatalogService _catalogService;

  List<TrainingModule> listPlugins() => _catalogService.list();
}
