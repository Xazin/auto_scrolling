import 'package:auto_scrolling/auto_scrolling.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AutoScroll widget', () {
    testWidgets('Scroll vertically', (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(_buildAutoScroll(controller));
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
        _buildAutoScroll(
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

    testWidgets('Scroll horizontally and cancel scroll', (tester) async {
      final controller = ScrollController();
      var isScrolling = false;
      await tester.pumpWidget(
        _buildAutoScroll(
          controller,
          scrollDirection: Axis.horizontal,
          onScrolling: (isS) => isScrolling = isS,
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.offset, 0.0);

      final center = tester.getCenter(find.byType(AutoScroll));

      await tester.tapAt(center, buttons: kMiddleMouseButton);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: center);
      await gesture.moveBy(const Offset(15, 0));
      await tester.pump(const Duration(seconds: 1));

      expect(isScrolling, true);

      await tester.tapAt(center, buttons: kMiddleMouseButton);
      await tester.pumpAndSettle();

      final currentOffset = controller.offset;

      expect(isScrolling, false);

      // We expect to not be at the beginning or end
      expect(controller.offset, isNot(controller.position.maxScrollExtent));
      expect(controller.offset, isNot(0));

      await tester.pump(const Duration(seconds: 1));

      // We expect currentOffset to not have changed
      expect(controller.offset, currentOffset);
    });

    testWidgets('Show anchor when auto scrolling', (tester) async {
      const anchorLabel = 'Anchor';
      final controller = ScrollController();
      await tester.pumpWidget(
        _buildAutoScroll(
          controller,
          scrollDirection: Axis.horizontal,
          anchorBuilder: (_) => const IgnorePointer(child: Text(anchorLabel)),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.offset, 0.0);

      final center = tester.getCenter(find.byType(AutoScroll));

      await tester.tapAt(center, buttons: kMiddleMouseButton);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: center);
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text(anchorLabel), findsOneWidget);

      await tester.tapAt(center, buttons: kMiddleMouseButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Auto scrolling has stopped, we should not see the anchor
      expect(find.text(anchorLabel), findsNothing);
    });

    testWidgets('Scroll vertically without releasing middle mouse button',
        (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(_buildAutoScroll(controller));
      await tester.pumpAndSettle();

      expect(controller.offset, 0.0);

      final center = tester.getCenter(find.byType(AutoScroll));

      final pointer = TestPointer(
        1,
        PointerDeviceKind.mouse,
        null,
        kMiddleMouseButton,
      )..hover(center);

      await tester.sendEventToBinding(
        pointer.down(center, buttons: kMiddleMouseButton),
      );
      await tester.sendEventToBinding(
        pointer.move(center + const Offset(0, 100)),
      );

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // We expect to be at the end, so the offset should be the maximum.
      expect(controller.offset, controller.position.maxScrollExtent);
    });
  });
}

Widget _buildAutoScroll(
  ScrollController controller, {
  Axis scrollDirection = Axis.vertical,
  void Function(bool isScrolling)? onScrolling,
  Widget Function(BuildContext)? anchorBuilder,
}) {
  return MaterialApp(
    home: Scaffold(
      body: AutoScroll(
        anchorBuilder: anchorBuilder,
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
