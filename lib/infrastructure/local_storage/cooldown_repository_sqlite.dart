import '../../engine/contracts/cooldown_repository.dart';

class CooldownRepositorySQLite implements CooldownRepository {
  final Map<String, CooldownRecord> _records = <String, CooldownRecord>{};

  @override
  Future<CooldownRecord?> findByPluginId(String pluginId) async {
    return _records[pluginId];
  }

  @override
  Future<void> save(CooldownRecord record) async {
    _records[record.pluginId] = record;
  }
}
