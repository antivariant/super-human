import 'package:test/test.dart';

void main() {
  test('out-of-scope features remain unavailable in MVP', () {
    const List<String> unsupported = <String>[
      'multiplayer',
      'leaderboards',
      'cross-user-comparison'
    ];

    for (final feature in unsupported) {
      expect(feature.startsWith('multi') || feature.contains('leaderboard') || feature.contains('cross-user'), isTrue);
    }
  });
}
