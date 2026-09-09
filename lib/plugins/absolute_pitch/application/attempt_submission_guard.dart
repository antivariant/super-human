import '../domain/absolute_pitch_attempt.dart';

class AttemptSubmissionGuard {
  const AttemptSubmissionGuard();

  void ensureCanSubmit(AbsolutePitchAttempt attempt) {
    if (attempt.state != AttemptState.answerOpen) {
      throw StateError('Only one guess is allowed per note.');
    }
  }
}
