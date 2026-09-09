import 'package:flutter/material.dart';

import '../../plugins/absolute_pitch/training_ui/absolute_pitch_training_screen.dart';

class TrainingSessionRoute {
  static Route<void> forPlugin(String pluginId) {
    if (pluginId == 'absolute_pitch') {
      return MaterialPageRoute<void>(
        builder: (_) => const AbsolutePitchTrainingScreen(),
      );
    }

    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Training')),
        body: Center(child: Text('Plugin "$pluginId" is not available.')),
      ),
    );
  }
}
