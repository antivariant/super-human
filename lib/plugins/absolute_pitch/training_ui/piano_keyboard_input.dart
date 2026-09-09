import 'package:flutter/material.dart';

class PianoKeyboardInput extends StatelessWidget {
  const PianoKeyboardInput({super.key, required this.onNoteSelected});

  final ValueChanged<String> onNoteSelected;

  static const List<String> _notes = <String>[
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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _notes
          .map((String note) => ElevatedButton(
                onPressed: () => onNoteSelected(note),
                child: Text(note),
              ))
          .toList(growable: false),
    );
  }
}
