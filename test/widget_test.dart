// This is a basic Flutter widget test for Stackova Company Project.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:stackova_company_project/main.dart';

void main() {
  testWidgets('Stackova app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StackovaApp());

    // Verify that the app loads and contains expected text.
    expect(find.text('STACKOVA'), findsOneWidget);
    expect(find.text('Professional Web Development'), findsOneWidget);

    // Verify that navigation elements are present.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });
}
