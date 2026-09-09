import 'package:test/test.dart';

import 'package:superhuman/infrastructure/local_storage/absolute_pitch_attempt_repository_sqlite.dart';
import 'package:superhuman/plugins/absolute_pitch/application/absolute_pitch_session_service.dart';
import 'package:superhuman/plugins/absolute_pitch/domain/absolute_pitch_attempt.dart';

void main() {
  test('enforces one submitted guess per note', () async {
    final service = AbsolutePitchSessionService(
      seed: 1,
      repository: AbsolutePitchAttemptRepositorySQLite(),
    );

    final attempt = service.startAttempt('a1');
    await service.submitAttempt(
      attempt: attempt,
      mode: SubmissionMode.keyboard,
      note: attempt.notePrompt,
      now: DateTime.utc(2026, 2, 13, 10, 0),
    );

    expect(
      () => service.submitAttempt(
        attempt: attempt,
        mode: SubmissionMode.keyboard,
        note: attempt.notePrompt,
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('allows delayed first submission with no forced timeout', () async {
    final service = AbsolutePitchSessionService(
      seed: 2,
      repository: AbsolutePitchAttemptRepositorySQLite(),
    );

    final attempt = service.startAttempt('a2');
    final delayedNow = DateTime.utc(2026, 2, 13, 10, 15);

    final completed = await service.submitAttempt(
      attempt: attempt,
      mode: SubmissionMode.voice,
      note: attempt.notePrompt,
      now: delayedNow,
    );

    expect(completed.submittedAt, delayedNow);
    expect(completed.isCorrect, isTrue);
  });
}
