// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:homepilot/main.dart';

void main() {
  testWidgets('HomePilot renders the task list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('HomePilot'), findsOneWidget);
    expect(find.text('Tâches du foyer'), findsOneWidget);
    expect(find.text('Faire la vaisselle'), findsOneWidget);
    expect(find.text('Sortir les poubelles'), findsOneWidget);
  });

  testWidgets('Adding a task works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('task_name_input')), 'Ranger le salon');
    await tester.tap(find.byKey(const ValueKey('add_task_dialog_button')));
    await tester.pumpAndSettle();

    expect(find.text('Ranger le salon'), findsOneWidget);
  });

  testWidgets('Adding and removing a room works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('new_room_input')), 'Garage');
    await tester.tap(find.byKey(const ValueKey('add_room_button')));
    await tester.pumpAndSettle();

    expect(find.text('Garage'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('remove_room_Garage')));
    await tester.pumpAndSettle();

    expect(find.text('Garage'), findsNothing);
  });

  testWidgets('Bottom navigation opens the shopping tab', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(BottomNavigationBar), findsOneWidget);

    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Liste des courses'), findsOneWidget);
    expect(find.text('Courses du foyer'), findsOneWidget);
  });
}
