import 'package:test/test.dart';

import 'package:superhuman/engine/cooldown/plugin_cooldown_service.dart';
import 'package:superhuman/infrastructure/local_storage/cooldown_repository_sqlite.dart';

void main() {
  test('blocks start while cooldown is active', () async {
    final CooldownRepositorySQLite repo = CooldownRepositorySQLite();
    final PluginCooldownService service = PluginCooldownService(repo);
    final DateTime now = DateTime.utc(2026, 2, 13, 12);

    await service.recordCompletedSession(
      pluginId: 'absolute_pitch',
      cooldownMinutes: 10,
      completedAt: now,
    );

    final bool immediate = await service.canStartSession('absolute_pitch', now);
    final bool after = await service.canStartSession(
      'absolute_pitch',
      now.add(const Duration(minutes: 10)),
    );

    expect(immediate, isFalse);
    expect(after, isTrue);
  });
}
