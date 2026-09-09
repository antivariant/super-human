import 'package:test/test.dart';

import 'package:superhuman/infrastructure/local_storage/absolute_pitch_attempt_repository_sqlite.dart';
import 'package:superhuman/plugins/absolute_pitch/application/absolute_pitch_session_service.dart';
import 'package:superhuman/plugins/absolute_pitch/domain/absolute_pitch_attempt.dart';

void main() {
  test('first submission accepted, second rejected', () async {
    final service = AbsolutePitchSessionService(
      seed: 5,
      repository: AbsolutePitchAttemptRepositorySQLite(),
    );
    final attempt = service.startAttempt('contract-a1');

    await service.submitAttempt(
      attempt: attempt,
      mode: SubmissionMode.keyboard,
      note: attempt.notePrompt,
      now: DateTime.utc(2026, 2, 13, 9),
    );

    expect(
      () => service.submitAttempt(
        attempt: attempt,
        mode: SubmissionMode.voice,
        note: attempt.notePrompt,
      ),
      throwsA(isA<StateError>()),
    );
  });
}
