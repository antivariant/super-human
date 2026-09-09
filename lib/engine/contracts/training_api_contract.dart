/// Internal non-HTTP service contract aligned to planning OpenAPI artifact.
abstract class TrainingApiContract {
  Future<List<TrainingPluginDto>> listPlugins();
  Future<CooldownStatusDto> getCooldownStatus(String pluginId);
  Future<TrainingSessionDto> startSession(String pluginId);
  Future<AttemptResultDto> submitAttempt({
    required String sessionId,
    required String attemptId,
    required String submissionMode,
    required String submittedNote,
  });
  Future<NextNoteResponseDto> requestNextNote(String sessionId);
  Future<void> requestRepeat(String sessionId);
  Future<List<PluginDashboardSummaryDto>> listPluginDashboardSummaries();
  Future<List<DashboardTrendPointDto>> getPluginTrends(String pluginId,
      {int days = 30});
}

class TrainingPluginDto {
  TrainingPluginDto({
    required this.pluginId,
    required this.name,
    required this.inputModalities,
    required this.resultType,
    this.cooldownMinutes,
  });

  final String pluginId;
  final String name;
  final List<String> inputModalities;
  final String resultType;
  final int? cooldownMinutes;
}

class TrainingSessionDto {
  TrainingSessionDto({
    required this.sessionId,
    required this.pluginId,
    required this.status,
  });

  final String sessionId;
  final String pluginId;
  final String status;
}

class AttemptResultDto {
  AttemptResultDto({
    required this.attemptId,
    required this.isCorrect,
    required this.nextAllowedAt,
  });

  final String attemptId;
  final bool isCorrect;
  final DateTime nextAllowedAt;
}

class NextNoteResponseDto {
  NextNoteResponseDto({required this.attemptId, required this.notePrompt});

  final String attemptId;
  final String notePrompt;
}

class CooldownStatusDto {
  CooldownStatusDto({
    required this.pluginId,
    required this.canStartSession,
    required this.canRequestNextNote,
    this.sessionNextAllowedAt,
    this.nextNoteAllowedAt,
  });

  final String pluginId;
  final bool canStartSession;
  final bool canRequestNextNote;
  final DateTime? sessionNextAllowedAt;
  final DateTime? nextNoteAllowedAt;
}

class PluginDashboardSummaryDto {
  PluginDashboardSummaryDto({
    required this.pluginId,
    required this.pluginName,
    required this.trendDirection,
    this.latestAccuracyRate,
  });

  final String pluginId;
  final String pluginName;
  final String trendDirection;
  final double? latestAccuracyRate;
}

class DashboardTrendPointDto {
  DashboardTrendPointDto({
    required this.day,
    required this.metricValue,
    required this.trendDirection,
  });

  final DateTime day;
  final double metricValue;
  final String trendDirection;
}
