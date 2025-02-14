import 'dart:async';

import 'package:flutter/material.dart';

/// A widget that wraps a [Scrollable] widget and enables auto-scrolling.
///
/// It provides 2 ways to engage auto-scrolling:
///  1. By pressing and releasing the middle mouse button, drag the cursor to
///   the desired direction.
///
///   The auto-scrolling will stay engaged until a click is made. This can be
///   done both by pressing the middle mouse button again or by pressing any
///   other mouse button.
///
///  2. By pressing the middle mouse button and dragging the cursor to the
///   desired direction.
///
///   The auto-scrolling will stay engaged until the middle mouse button
///   is released.
///
class AutoScroll extends StatefulWidget {
  /// Creates an [AutoScroll] widget.
  ///
  const AutoScroll({
    super.key,
    required this.controller,
    this.scrollDirection = Axis.vertical,
    this.onScrolling,
    this.deadZoneRadius = 10,
    this.velocity = 0.2,
    this.scrollTick = 15,
    required this.child,
  });

  /// The [ScrollController] attached to the [Scrollable] widget.
  ///
  /// This has to be the same controller that is attached to
  /// the [Scrollable] widget.
  ///
  final ScrollController controller;

  /// The direction of the scroll.
  ///
  /// Defaults to [Axis.vertical].
  ///
  final Axis scrollDirection;

  /// A callback that is called when the scroll engages or disengages.
  ///
  final void Function(bool isScrolling)? onScrolling;

  /// A radius around the start position of the cursor, where the scrolling
  /// will not engage.
  ///
  /// Defaults to 10 pixels.
  ///
  final int deadZoneRadius;

  /// The velocity of the scroll, can be used to adjust the speed by a factor.
  ///
  /// The higher the value, the faster the scroll.
  ///
  /// Defaults to 0.2.
  ///
  final double velocity;

  /// The time in milliseconds between each scroll tick.
  ///
  /// Can be used in tandem with [velocity] to fine-tune the scroll speed. It
  /// is generally not recommended to change this value, as it can lead to
  /// visual issues such as stuttering due to the delay in scrolling.
  ///
  /// The lower the value, the smoother and faster the scroll will be. However,
  /// it will also trigger more often, which can be a performance trade-off for
  /// complex scrollable widgets.
  ///
  /// If the value is too low, it can also lead to the scroll being too fast
  /// and uncontrollable. It is recommended to test the scroll speed with the
  /// default value before changing it.
  ///
  /// Defaults to 15 milliseconds.
  ///
  ///
  final int scrollTick;

  /// The child [Widget].
  ///
  final Widget child;

  @override
  State<AutoScroll> createState() => _AutoScrollState();
}

class _AutoScrollState extends State<AutoScroll> {
  int pointerTime = 0;
  bool isScrolling = false;

  Offset? startOffset;
  Offset? cursorOffset;

  Timer? scrollTimer;

  @override
  void dispose() {
    scrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isScrolling ? SystemMouseCursors.move : MouseCursor.defer,
      // This is used to detect the cursor position, in the case where
      // auto scrolling is engaged by middle mouse click rather than
      // middle mouse click+drag.
      onHover: (event) {
        if (isScrolling) {
          updateCursorOffset(event.position);
          pointerTime = DateTime.now().millisecondsSinceEpoch;
        }
      },
      child: Listener(
        onPointerDown: (event) {
          if (isScrolling) {
            return stopScrolling();
          }

          if (event.buttons != 4) return;

          pointerTime = DateTime.now().millisecondsSinceEpoch;

          setState(() {
            startOffset = event.position;
            cursorOffset = event.position;
            isScrolling = true;
          });

          startScrolling();
        },
        onPointerUp: (event) {
          if (pointerTime + 500 < DateTime.now().millisecondsSinceEpoch) {
            stopScrolling();
          }
        },
        onPointerMove: (event) {
          if (event.buttons != 4 || !isScrolling) return;

          updateCursorOffset(event.position);
        },
        child: widget.child,
      ),
    );
  }

  /// Starts scrolling according to the cursors placement compared to the
  /// start offset.
  ///
  /// This method starts a timer, that will repeatedly move the position of
  /// the [ScrollController].
  ///
  void startScrolling() {
    // Notify that scrolling has started.
    widget.onScrolling?.call(true);

    scrollTimer?.cancel();
    scrollTimer =
        Timer.periodic(Duration(milliseconds: widget.scrollTick), (timer) {
      if (!isScrolling || startOffset == null || cursorOffset == null) {
        return scrollTimer?.cancel();
      }

      if (!shouldMove()) return;

      final move = switch (widget.scrollDirection) {
        Axis.horizontal => startOffset!.dx - cursorOffset!.dx,
        Axis.vertical => startOffset!.dy - cursorOffset!.dy,
      };

      widget.controller.position.moveTo(
        widget.controller.position.pixels - move * widget.velocity,
      );
    });
  }

  /// Stops scrolling by cancelling the timer and resetting the state.
  ///
  void stopScrolling() {
    if (!isScrolling) return;

    setState(() {
      scrollTimer?.cancel();
      isScrolling = false;
      startOffset = null;
      cursorOffset = null;
      pointerTime = 0;
    });

    // Notify that scrolling has ended.
    widget.onScrolling?.call(false);
  }

  /// Updates the cursor offset.
  ///
  void updateCursorOffset(Offset offset) =>
      setState(() => cursorOffset = offset);

  /// Checks whether the cursor has moved out of the deadZoneRadius from
  /// the [startOffset].
  ///
  /// Returns `true` if the cursor has moved out of the dead zone,
  /// otherwise `false`.
  ///
  bool shouldMove() {
    final dx = (cursorOffset!.dx - startOffset!.dx).abs();
    final dy = (cursorOffset!.dy - startOffset!.dy).abs();
    if (dx < widget.deadZoneRadius && dy < widget.deadZoneRadius) {
      return false;
    }

    return true;
  }
}
