import 'package:flutter/material.dart';

import '../../../infrastructure/local_storage/absolute_pitch_attempt_repository_sqlite.dart';
import '../../../infrastructure/speech/note_recognition_adapter.dart';
import '../application/absolute_pitch_session_service.dart';
import '../domain/absolute_pitch_attempt.dart';
import 'piano_keyboard_input.dart';

class AbsolutePitchTrainingScreen extends StatefulWidget {
  const AbsolutePitchTrainingScreen({super.key});

  @override
  State<AbsolutePitchTrainingScreen> createState() => _AbsolutePitchTrainingScreenState();
}

class _AbsolutePitchTrainingScreenState extends State<AbsolutePitchTrainingScreen> {
  late final AbsolutePitchSessionService _service;
  final TextEditingController _voiceController = TextEditingController();
  final NoteRecognitionAdapter _speech = NoteRecognitionAdapter();

  AbsolutePitchAttempt? _attempt;
  bool _showKeyboard = false;
  String _message = 'Press start to begin.';

  @override
  void initState() {
    super.initState();
    _service = AbsolutePitchSessionService(
      seed: 42,
      repository: AbsolutePitchAttemptRepositorySQLite(),
    );
  }

  @override
  void dispose() {
    _voiceController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final AbsolutePitchAttempt attempt = _service.startAttempt(DateTime.now().microsecondsSinceEpoch.toString());
    setState(() {
      _attempt = attempt;
      _showKeyboard = true;
      _message = 'Identify the note. One guess only.';
    });
  }

  Future<void> _submitKeyboard(String note) async {
    final AbsolutePitchAttempt? attempt = _attempt;
    if (attempt == null) {
      return;
    }
    try {
      final AbsolutePitchAttempt completed = await _service.submitAttempt(
        attempt: attempt,
        mode: SubmissionMode.keyboard,
        note: note,
      );
      setState(() {
        _showKeyboard = false;
        _message = completed.isCorrect == true ? 'Correct' : 'Incorrect';
      });
    } on StateError catch (err) {
      setState(() {
        _message = err.message;
      });
    }
  }

  Future<void> _submitVoice() async {
    final String? normalized = _speech.normalize(_voiceController.text);
    if (normalized == null) {
      setState(() {
        _message = 'Voice input not recognized as a note name.';
      });
      return;
    }
    await _submitKeyboard(normalized);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Absolute Pitch')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_message),
            const SizedBox(height: 16),
            if (_attempt == null)
              ElevatedButton(onPressed: _start, child: const Text('Start attempt')),
            if (_showKeyboard) ...<Widget>[
              const PianoKeyboardPlaceholder(),
              const SizedBox(height: 8),
              PianoKeyboardInput(onNoteSelected: _submitKeyboard),
              const SizedBox(height: 12),
              TextField(controller: _voiceController, decoration: const InputDecoration(labelText: 'Voice note name')), 
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _submitVoice, child: const Text('Submit voice answer')),
            ]
          ],
        ),
      ),
    );
  }
}

class PianoKeyboardPlaceholder extends StatelessWidget {
  const PianoKeyboardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Keyboard visible after note playback.');
  }
}
