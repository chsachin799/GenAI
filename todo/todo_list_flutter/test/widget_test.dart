import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_flutter/main.dart';

void main() {
  testWidgets('Sankalp App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SankalpApp());
    await tester.pumpAndSettle();

    // Verify app title renders
    expect(find.text('Sankalp'), findsOneWidget);
    expect(find.text('Morning Wake-Up Kickstart'), findsOneWidget);
  });
}
