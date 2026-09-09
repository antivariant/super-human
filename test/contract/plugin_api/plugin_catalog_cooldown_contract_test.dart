import 'package:test/test.dart';

import 'package:superhuman/engine/cooldown/plugin_cooldown_service.dart';
import 'package:superhuman/engine/core/plugin_catalog_service.dart';
import 'package:superhuman/infrastructure/local_storage/cooldown_repository_sqlite.dart';
import 'package:superhuman/plugins/absolute_pitch/application/absolute_pitch_plugin_module.dart';

void main() {
  test('catalog lists absolute pitch and cooldown returns gating values', () async {
    final catalog = PluginCatalogService(<AbsolutePitchPluginModule>[AbsolutePitchPluginModule()]);
    final plugins = catalog.list();
    expect(plugins.single.pluginId, 'absolute_pitch');

    final cooldown = PluginCooldownService(CooldownRepositorySQLite());
    final now = DateTime.utc(2026, 2, 13, 10);
    await cooldown.recordCompletedSession(
      pluginId: 'absolute_pitch',
      cooldownMinutes: 10,
      completedAt: now,
    );
    expect(await cooldown.canStartSession('absolute_pitch', now), isFalse);
  });
}
