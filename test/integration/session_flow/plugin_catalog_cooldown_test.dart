import 'package:test/test.dart';

import 'package:superhuman/app/plugin_catalog/plugin_launch_guard.dart';
import 'package:superhuman/engine/cooldown/plugin_cooldown_service.dart';
import 'package:superhuman/infrastructure/local_storage/cooldown_repository_sqlite.dart';

void main() {
  test('launch guard blocks plugin during cooldown and allows after', () async {
    final service = PluginCooldownService(CooldownRepositorySQLite());
    final guard = PluginLaunchGuard(service);
    final now = DateTime.utc(2026, 2, 13, 12);

    await service.recordCompletedSession(
      pluginId: 'absolute_pitch',
      cooldownMinutes: 10,
      completedAt: now,
    );

    final blocked = await guard.canLaunch('absolute_pitch', now);
    final allowed = await guard.canLaunch('absolute_pitch', now.add(const Duration(minutes: 10)));

    expect(blocked.allowed, isFalse);
    expect(allowed.allowed, isTrue);
  });
}
