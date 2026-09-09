class DeterministicNoteGenerator {
  DeterministicNoteGenerator({required int seed}) : _state = seed;

  static const List<String> chromaticNotes = <String>[
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];

  int _state;

  String nextNote() {
    _state = (_state * 1103515245 + 12345) & 0x7fffffff;
    return chromaticNotes[_state % chromaticNotes.length];
  }
}
