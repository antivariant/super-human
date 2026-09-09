import '../../../engine/contracts/training_module.dart';

class AbsolutePitchPluginModule implements TrainingModule {
  @override
  int? get cooldownMinutes => 10;

  @override
  String get displayName => 'Absolute Pitch';

  @override
  List<String> get inputModalities => <String>['voice', 'keyboard'];

  @override
  String get pluginId => 'absolute_pitch';

  @override
  String get resultType => 'boolean';
}
