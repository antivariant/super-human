import '../../plugins/absolute_pitch/domain/absolute_pitch_attempt.dart';

class AbsolutePitchAttemptRepositorySQLite {
  final Map<String, AbsolutePitchAttempt> _store = <String, AbsolutePitchAttempt>{};

  Future<void> saveAttempt(AbsolutePitchAttempt attempt) async {
    _store[attempt.attemptId] = attempt;
  }

  Future<AbsolutePitchAttempt?> findAttempt(String attemptId) async {
    return _store[attemptId];
  }

  Future<List<AbsolutePitchAttempt>> listAttempts() async {
    return _store.values.toList(growable: false);
  }
}
