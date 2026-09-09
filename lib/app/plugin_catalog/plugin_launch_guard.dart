import '../../engine/cooldown/plugin_cooldown_service.dart';

class PluginLaunchGuard {
  PluginLaunchGuard(this._cooldownService);

  final PluginCooldownService _cooldownService;

  Future<LaunchDecision> canLaunch(String pluginId, DateTime now) async {
    final bool allowed = await _cooldownService.canStartSession(pluginId, now);
    if (allowed) {
      return LaunchDecision.allowed();
    }
    final DateTime? nextAllowedAt = await _cooldownService.nextAllowedAt(pluginId);
    return LaunchDecision.blocked(nextAllowedAt);
  }
}

class LaunchDecision {
  LaunchDecision._({required this.allowed, this.nextAllowedAt});

  factory LaunchDecision.allowed() => LaunchDecision._(allowed: true);
  factory LaunchDecision.blocked(DateTime? nextAllowedAt) =>
      LaunchDecision._(allowed: false, nextAllowedAt: nextAllowedAt);

  final bool allowed;
  final DateTime? nextAllowedAt;
}
