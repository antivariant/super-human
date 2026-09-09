import 'package:flutter_test/flutter_test.dart';
import 'package:superhuman/main.dart';

void main() {
  testWidgets('SuperHuman app renders plugin catalog title',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SuperHumanApp());
    expect(find.text('Training Plugins'), findsOneWidget);
  });
}
