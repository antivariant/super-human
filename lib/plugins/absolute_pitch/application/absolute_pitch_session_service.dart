import '../../../infrastructure/local_storage/absolute_pitch_attempt_repository_sqlite.dart';
import '../domain/absolute_pitch_attempt.dart';
import '../domain/absolute_pitch_note_sequence.dart';
import 'attempt_submission_guard.dart';
import 'next_note_lock_service.dart';

class AbsolutePitchSessionService {
  AbsolutePitchSessionService({
    required int seed,
    required AbsolutePitchAttemptRepositorySQLite repository,
    AttemptSubmissionGuard? submissionGuard,
    NextNoteLockService? lockService,
  })  : _noteSequence = AbsolutePitchNoteSequence(seed: seed),
        _repository = repository,
        _submissionGuard = submissionGuard ?? const AttemptSubmissionGuard(),
        _lockService = lockService ?? const NextNoteLockService();

  final AbsolutePitchNoteSequence _noteSequence;
  final AbsolutePitchAttemptRepositorySQLite _repository;
  final AttemptSubmissionGuard _submissionGuard;
  final NextNoteLockService _lockService;

  AbsolutePitchAttempt startAttempt(String attemptId) {
    final AbsolutePitchAttempt attempt =
        AbsolutePitchAttempt(attemptId: attemptId, notePrompt: _noteSequence.nextPrompt());
    attempt.openAnswer();
    return attempt;
  }

  Future<AbsolutePitchAttempt> submitAttempt({
    required AbsolutePitchAttempt attempt,
    required SubmissionMode mode,
    required String note,
    DateTime? now,
  }) async {
    _submissionGuard.ensureCanSubmit(attempt);
    final DateTime submittedAt = now ?? DateTime.now().toUtc();
    attempt.submit(mode: mode, note: note, now: submittedAt);
    attempt.lockForNextNote(_lockService.lockDuration);
    await _repository.saveAttempt(attempt);
    return attempt;
  }

  bool canRequestNext(AbsolutePitchAttempt attempt, DateTime now) {
    final DateTime? nextAllowedAt = attempt.nextAllowedAt;
    if (nextAllowedAt == null) {
      return true;
    }
    return _lockService.canRequestNext(now, nextAllowedAt);
  }
}
