import 'package:auto_scrolling/auto_scrolling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Custom cursor test', () {
    testWidgets('can render AutoScrollCustomCursor', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AutoScrollCustomCursor(
                parentKey: GlobalKey(),
                cursorOffset: Offset.zero,
                direction: AutoScrollDirection.up,
                cursorBuilder: (_) => Container(
                  width: 10,
                  height: 10,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AutoScrollCustomCursor), findsOneWidget);
    });
    testWidgets('can render DirectionArrow (all types)', (tester) async {
      final children = <Widget>[];

      for (final value in AutoScrollDirection.values) {
        children.add(DirectionArrow(direction: value));
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Column(children: children)),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(DirectionArrow),
        findsNWidgets(AutoScrollDirection.values.length),
      );
    });
  });
}
