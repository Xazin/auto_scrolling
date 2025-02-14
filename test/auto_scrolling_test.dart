import 'package:auto_scrolling/auto_scrolling.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AutoScroll widget', () {
    testWidgets('Scroll vertically', (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(buildAutoScroll(controller));
      await tester.pumpAndSettle();

      expect(controller.offset, 0.0);

      final center = tester.getCenter(find.byType(AutoScroll));

      await tester.tapAt(center, buttons: kMiddleMouseButton);
      await tester.pump();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: center);
      await tester.pump();

      await gesture.moveBy(const Offset(0, 100));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // We expect to be at the end, so the offset should be the maximum.
      expect(controller.offset, controller.position.maxScrollExtent);
    });

    testWidgets('Scroll horizontally', (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(
        buildAutoScroll(
          controller,
          scrollDirection: Axis.horizontal,
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.offset, 0.0);

      final center = tester.getCenter(find.byType(AutoScroll));

      await tester.tapAt(center, buttons: kMiddleMouseButton);
      await tester.pump();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: center);
      await tester.pump();

      await gesture.moveBy(const Offset(100, 0));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // We expect to be at the end, so the offset should be the maximum.
      expect(controller.offset, controller.position.maxScrollExtent);
    });
  });
}

Widget buildAutoScroll(
  ScrollController controller, {
  Axis scrollDirection = Axis.vertical,
  void Function(bool isScrolling)? onScrolling,
}) {
  return MaterialApp(
    home: Scaffold(
      body: AutoScroll(
        controller: controller,
        scrollDirection: scrollDirection,
        onScrolling: onScrolling,
        child: ListView.builder(
          controller: controller,
          scrollDirection: scrollDirection,
          itemCount: 100,
          itemBuilder: (_, __) => const SizedBox(height: 500, width: 500),
        ),
      ),
    ),
  );
}
