class NextNoteLockService {
  const NextNoteLockService({this.lockDuration = const Duration(minutes: 10)});

  final Duration lockDuration;

  DateTime calculateNextAllowedAt(DateTime submittedAt) {
    return submittedAt.add(lockDuration);
  }

  bool canRequestNext(DateTime now, DateTime nextAllowedAt) {
    return !now.isBefore(nextAllowedAt);
  }
}
