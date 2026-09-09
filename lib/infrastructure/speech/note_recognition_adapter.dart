class NoteRecognitionAdapter {
  static const Map<String, String> _aliases = <String, String>{
    'C SHARP': 'C#',
    'D SHARP': 'D#',
    'F SHARP': 'F#',
    'G SHARP': 'G#',
    'A SHARP': 'A#',
  };

  String? normalize(String spokenText) {
    final String normalized = spokenText.trim().toUpperCase();
    if (normalized.isEmpty) {
      return null;
    }
    if (_aliases.containsKey(normalized)) {
      return _aliases[normalized];
    }
    const List<String> notes = <String>[
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
    return notes.contains(normalized) ? normalized : null;
  }
}
