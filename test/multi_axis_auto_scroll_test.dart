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
    });
  });
}

Widget _buildAutoScroll(
  ScrollController verticalController,
  ScrollController horizontalController, {
  void Function(bool isScrolling)? onScrolling,
}) {
  return MaterialApp(
    home: Scaffold(
      body: MultiAxisAutoScroll(
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
