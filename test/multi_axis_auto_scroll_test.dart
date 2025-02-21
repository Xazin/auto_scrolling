import 'package:auto_scrolling/auto_scrolling.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AutoScroll widget', () {
    testWidgets('Auto scroll disabled without enough space to scroll',
        (tester) async {
      var isScrolling = false;
      final verticalController = ScrollController();
      final horizontalController = ScrollController();
      await tester.pumpWidget(
        _buildAutoScroll(
          verticalController,
          horizontalController,
          addVerticalScrollSpace: false,
          addHorizontalScrollSpace: false,
          onScrolling: (isS) => isScrolling = isS,
        ),
      );
      await tester.pumpAndSettle();

      expect(isScrolling, false);
      expect(verticalController.position.maxScrollExtent, 0.0);
      expect(horizontalController.position.maxScrollExtent, 0.0);

      final center = tester.getCenter(find.byType(MultiAxisAutoScroll));

      await tester.tapAt(center, buttons: kMiddleMouseButton);
      await tester.pump();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: center);
      await tester.pump();

      expect(isScrolling, false);

      await gesture.moveBy(const Offset(200, 200));
      await tester.pumpAndSettle();

      expect(isScrolling, false);

      // Move up and left (reverse direction)
      await gesture.moveBy(const Offset(-400, -400));
      await tester.pumpAndSettle();

      expect(isScrolling, false);
    });
    testWidgets('Scroll vertically and horizontally', (tester) async {
      final verticalController = ScrollController();
      final horizontalController = ScrollController();
      await tester.pumpWidget(
        _buildAutoScroll(
          verticalController,
          horizontalController,
          anchorBuilder: (_) => ReactiveDirectionAnchor(
            verticalController: verticalController,
            horizontalController: horizontalController,
          ),
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

  testWidgets('Custom cursor vertically', (tester) async {
    const upLabel = 'UP';
    const downLabel = 'DOWN';

    final verticalController = ScrollController();
    final horizontalController = ScrollController();

    await tester.pumpWidget(
      _buildAutoScroll(
        verticalController,
        horizontalController,
        willUseCustomCursor: (direction) => [
          AutoScrollDirection.up,
          AutoScrollDirection.down
        ].contains(direction),
        cursorBuilder: (direction) {
          if (direction == AutoScrollDirection.up) {
            return const Text(upLabel);
          } else if (direction == AutoScrollDirection.down) {
            return const Text(downLabel);
          }

          return null;
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(verticalController.offset, 0.0);

    final center = tester.getCenter(find.byType(MultiAxisAutoScroll));

    await tester.tapAt(center, buttons: kMiddleMouseButton);
    await tester.pump();

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: center);
    await tester.pump();

    expect(find.text(upLabel), findsNothing);
    expect(find.text(downLabel), findsNothing);

    await gesture.moveBy(const Offset(0, 15));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(downLabel), findsOneWidget);
    expect(find.text(upLabel), findsNothing);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    // We expect to not be at the start
    expect(verticalController.offset, isNot(0.0));

    // Move cursor to anchor, and stop scrolling
    await gesture.moveTo(center);
    await tester.pump(const Duration(milliseconds: 500));

    // Now we scroll up to test the other version of the cursor
    await gesture.moveTo(center + const Offset(0, -15));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(upLabel), findsOneWidget);
    expect(find.text(downLabel), findsNothing);

    await tester.pumpAndSettle(const Duration(seconds: 6));

    // We expect to be at the beginning, so the offset should be 0.
    expect(verticalController.offset, 0.0);
  });
}

Widget _buildAutoScroll(
  ScrollController verticalController,
  ScrollController horizontalController, {
  bool addVerticalScrollSpace = true,
  bool addHorizontalScrollSpace = true,
  void Function(bool isScrolling)? onScrolling,
  Widget Function(BuildContext)? anchorBuilder,
  Widget? Function(AutoScrollDirection)? cursorBuilder,
  bool Function(AutoScrollDirection)? willUseCustomCursor,
}) {
  return MaterialApp(
    home: Scaffold(
      body: MultiAxisAutoScroll(
        willUseCustomCursor: willUseCustomCursor,
        cursorBuilder: cursorBuilder,
        anchorBuilder: anchorBuilder,
        verticalController: verticalController,
        horizontalController: horizontalController,
        onScrolling: onScrolling,
        child: SingleChildScrollView(
          controller: verticalController,
          child: SingleChildScrollView(
            controller: horizontalController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: addHorizontalScrollSpace ? 10000 : 100,
              height: addVerticalScrollSpace ? 10000 : 100,
            ),
          ),
        ),
      ),
    ),
  );
}
