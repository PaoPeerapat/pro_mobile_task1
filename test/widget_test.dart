import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_project1/main.dart';

void main() {
  testWidgets('Task Manager UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that we see the Home screen with a title.
    expect(find.text('Task Manager'), findsOneWidget);
    expect(find.text('No tasks yet!'), findsOneWidget);

    // Tap the '+' icon to add a new task.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Enter a task title
    await tester.enterText(find.byType(TextField), 'New Task');
    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    // Verify that the new task is displayed on the Home screen.
    expect(find.text('New Task'), findsOneWidget);
    expect(find.text('No tasks yet!'), findsNothing);

    // Tap the delete icon of the task.
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    // Verify that the task is removed.
    expect(find.text('New Task'), findsNothing);
  });
}
