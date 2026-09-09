import 'package:test/test.dart';

import 'package:superhuman/infrastructure/local_storage/absolute_pitch_attempt_repository_sqlite.dart';
import 'package:superhuman/plugins/absolute_pitch/application/absolute_pitch_session_service.dart';
import 'package:superhuman/plugins/absolute_pitch/domain/absolute_pitch_attempt.dart';

void main() {
  test('enforces 10 minute lock after submission', () async {
    final service = AbsolutePitchSessionService(
      seed: 8,
      repository: AbsolutePitchAttemptRepositorySQLite(),
    );
    final attempt = service.startAttempt('i1');
    final submittedAt = DateTime.utc(2026, 2, 13, 10, 0);

    final completed = await service.submitAttempt(
      attempt: attempt,
      mode: SubmissionMode.keyboard,
      note: attempt.notePrompt,
      now: submittedAt,
    );

    expect(service.canRequestNext(completed, submittedAt.add(const Duration(minutes: 9))),
        isFalse);
    expect(service.canRequestNext(completed, submittedAt.add(const Duration(minutes: 10))),
        isTrue);
  });
}
