import 'package:test/test.dart';

import 'package:superhuman/engine/core/deterministic_note_generator.dart';

void main() {
  test('deterministic note generator returns same sequence for same seed', () {
    final DeterministicNoteGenerator a = DeterministicNoteGenerator(seed: 7);
    final DeterministicNoteGenerator b = DeterministicNoteGenerator(seed: 7);

    final List<String> seqA = List<String>.generate(6, (_) => a.nextNote());
    final List<String> seqB = List<String>.generate(6, (_) => b.nextNote());

    expect(seqA, equals(seqB));
  });
}
