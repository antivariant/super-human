enum AttemptState { notePlaying, answerOpen, answered, lockedForNextNote }

enum SubmissionMode { voice, keyboard }

class AbsolutePitchAttempt {
  AbsolutePitchAttempt({required this.attemptId, required this.notePrompt})
      : state = AttemptState.notePlaying,
        playbackStartedAt = DateTime.now().toUtc();

  final String attemptId;
  final String notePrompt;
  final DateTime playbackStartedAt;
  AttemptState state;
  DateTime? answerOpenedAt;
  DateTime? submittedAt;
  DateTime? nextAllowedAt;
  SubmissionMode? submissionMode;
  String? submittedNote;
  bool? isCorrect;

  void openAnswer() {
    if (state != AttemptState.notePlaying) {
      throw StateError('Attempt is not in playback state.');
    }
    state = AttemptState.answerOpen;
    answerOpenedAt = DateTime.now().toUtc();
  }

  void submit({
    required SubmissionMode mode,
    required String note,
    required DateTime now,
  }) {
    if (state != AttemptState.answerOpen) {
      throw StateError('Attempt already answered or not ready.');
    }
    submissionMode = mode;
    submittedNote = note;
    submittedAt = now;
    isCorrect = note.trim().toUpperCase() == notePrompt.toUpperCase();
    state = AttemptState.answered;
  }

  void lockForNextNote(Duration lockDuration) {
    if (state != AttemptState.answered || submittedAt == null) {
      throw StateError('Attempt must be answered before lock.');
    }
    nextAllowedAt = submittedAt!.add(lockDuration);
    state = AttemptState.lockedForNextNote;
  }
}
