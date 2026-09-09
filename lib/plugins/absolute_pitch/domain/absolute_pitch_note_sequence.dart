import '../../../engine/core/deterministic_note_generator.dart';

class AbsolutePitchNoteSequence {
  AbsolutePitchNoteSequence({required int seed})
      : _generator = DeterministicNoteGenerator(seed: seed);

  final DeterministicNoteGenerator _generator;

  String nextPrompt() => _generator.nextNote();
}
