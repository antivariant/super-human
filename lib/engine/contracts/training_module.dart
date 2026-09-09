abstract class TrainingModule {
  String get pluginId;
  String get displayName;
  List<String> get inputModalities;
  String get resultType;
  int? get cooldownMinutes;
}
