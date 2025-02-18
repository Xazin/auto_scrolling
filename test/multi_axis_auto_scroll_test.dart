import 'package:auto_scrolling/auto_scrolling.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AutoScroll widget', () {
    testWidgets('Scroll vertically and horizontally', (tester) async {
      final verticalController = ScrollController();
      final horizontalController = ScrollController();
      await tester.pumpWidget(
        _buildAutoScroll(
          verticalController,
          horizontalController,
        ),
      );
      await tester.pumpAndSettle();

      expect(verticalController.offset, 0.0);
      expect(horizontalController.offset, 0.0);

      final center = tester.getCenter(find.byType(MultiAxisAutoScroll));

      await tester.tapAt(center, buttons: kMiddleMouseButton);
      await tester.pump();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: center);
      await tester.pump();

      await gesture.moveBy(const Offset(200, 200));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // We expect to be at the end, so the offset should be the maximum,
      // both vertically and horizontally.
      expect(
        verticalController.offset,
        verticalController.position.maxScrollExtent,
      );
      expect(
        horizontalController.offset,
        horizontalController.position.maxScrollExtent,
      );

      // Move up and left (reverse direction)
      await gesture.moveBy(const Offset(-400, -400));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // We expect to be at the beginning, so the offset should be 0,
      // both vertically and horizontally.
      expect(verticalController.offset, 0.0);
      expect(horizontalController.offset, 0.0);
    });

    testWidgets('Scroll vertically and cancel scroll', (tester) async {
      final verticalController = ScrollController();
      final horizontalController = ScrollController();

      var isScrolling = false;

      await tester.pumpWidget(
        _buildAutoScroll(
          verticalController,
          horizontalController,
          onScrolling: (isS) => isScrolling = isS,
        ),
      );
      await tester.pumpAndSettle();

      expect(verticalController.offset, 0.0);
      expect(horizontalController.offset, 0.0);

      final center = tester.getCenter(find.byType(MultiAxisAutoScroll));

      await tester.tapAt(center, buttons: kMiddleMouseButton);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: center);
      await gesture.moveBy(const Offset(0, 15));
      await tester.pump(const Duration(seconds: 1));

      expect(isScrolling, true);

      await tester.tapAt(center, buttons: kMiddleMouseButton);
      await tester.pumpAndSettle();

      final currentVerticalOffset = verticalController.offset;

      expect(isScrolling, false);

      // We expect to not be at the beginning or end vertically
      expect(
        verticalController.offset,
        isNot(verticalController.position.maxScrollExtent),
      );
      expect(verticalController.offset, isNot(0));

      // We expect horizontal offset to not have changed
      expect(horizontalController.offset, 0.0);

      await tester.pump(const Duration(seconds: 1));

      // We expect currentVerticalOffset to not have changed
      expect(verticalController.offset, currentVerticalOffset);
    });

    testWidgets('Show anchor when auto scrolling', (tester) async {
      final verticalController = ScrollController();
      final horizontalController = ScrollController();

      const anchorLabel = 'Anchor';
      await tester.pumpWidget(
        _buildAutoScroll(
          verticalController,
          horizontalController,
          anchorBuilder: (_) => const IgnorePointer(child: Text(anchorLabel)),
        ),
      );
      await tester.pumpAndSettle();

      expect(verticalController.offset, 0.0);

      final center = tester.getCenter(find.byType(MultiAxisAutoScroll));

      await tester.tapAt(center, buttons: kMiddleMouseButton);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: center);
      await gesture.moveBy(const Offset(0, 20));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text(anchorLabel), findsOneWidget);

      await tester.tapAt(center, buttons: kMiddleMouseButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Auto scrolling has stopped, we should not see the anchor
      expect(find.text(anchorLabel), findsNothing);
    });
  });
}

Widget _buildAutoScroll(
  ScrollController verticalController,
  ScrollController horizontalController, {
  void Function(bool isScrolling)? onScrolling,
  Widget Function(BuildContext)? anchorBuilder,
}) {
  return MaterialApp(
    home: Scaffold(
      body: MultiAxisAutoScroll(
        anchorBuilder: anchorBuilder,
        verticalController: verticalController,
        horizontalController: horizontalController,
        onScrolling: onScrolling,
        child: SingleChildScrollView(
          controller: verticalController,
          child: SingleChildScrollView(
            controller: horizontalController,
            scrollDirection: Axis.horizontal,
            child: const SizedBox(
              width: 10000,
              height: 10000,
            ),
          ),
        ),
      ),
    ),
  );
}
