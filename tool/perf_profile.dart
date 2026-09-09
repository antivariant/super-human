import 'package:superhuman/infrastructure/local_storage/absolute_pitch_attempt_repository_sqlite.dart';
import 'package:superhuman/plugins/absolute_pitch/application/absolute_pitch_session_service.dart';
import 'package:superhuman/plugins/absolute_pitch/domain/absolute_pitch_attempt.dart';
import 'dart:io';

void main() async {
  final AbsolutePitchSessionService service = AbsolutePitchSessionService(
    seed: 42,
    repository: AbsolutePitchAttemptRepositorySQLite(),
  );

  const int iterations = 5000;
  final Stopwatch sw = Stopwatch();

  sw.start();
  for (int i = 0; i < iterations; i++) {
    final AbsolutePitchAttempt attempt = service.startAttempt('p$i');
    await service.submitAttempt(
      attempt: attempt,
      mode: SubmissionMode.keyboard,
      note: attempt.notePrompt,
      now: DateTime.utc(2026, 2, 13, 12, 0).add(Duration(milliseconds: i)),
    );
    service.canRequestNext(attempt, DateTime.utc(2026, 2, 13, 12, 10));
  }
  sw.stop();

  final double totalMs = sw.elapsedMicroseconds / 1000.0;
  final double perIterationMs = totalMs / iterations;

  stdout.writeln('iterations=$iterations');
  stdout.writeln('total_ms=${totalMs.toStringAsFixed(3)}');
  stdout.writeln('avg_ms=${perIterationMs.toStringAsFixed(6)}');
}
