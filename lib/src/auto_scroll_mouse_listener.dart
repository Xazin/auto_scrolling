import 'package:flutter/material.dart';

/// A helper widget that listens to the mouse events and provides callbacks
/// for when auto scrolling should be engaged/disengaged, and when the
/// cursor is moved while auto scrolling is engaged.
///
class AutoScrollMouseListener extends StatefulWidget {
  /// Creates an [AutoScrollMouseListener] widget.
  ///
  const AutoScrollMouseListener({
    super.key,
    this.onStartScrolling,
    this.onEndScrolling,
    this.onMouseMoved,
    required this.child,
  });

  /// A callback that is called when the scrolling is engaged.
  ///
  final void Function(Offset startOffset)? onStartScrolling;

  /// A callback that is called when the scrolling is disengaged.
  ///
  final void Function()? onEndScrolling;

  /// A callback that is called when the mouse is moved.
  ///
  /// The callback is only called if scrolling is engaged.
  ///
  /// The startOffset is the position where the scrolling was engaged.
  /// The cursorOffset is the current position of the cursor.
  ///
  final void Function(Offset startOffset, Offset cursorOffset)? onMouseMoved;

  /// The child [Widget].
  ///
  final Widget child;

  @override
  State<AutoScrollMouseListener> createState() =>
      _AutoScrollMouseListenerState();
}

class _AutoScrollMouseListenerState extends State<AutoScrollMouseListener> {
  bool isScrolling = false;
  int pointerTime = 0;
  Offset? startOffset;

  @override
  Widget build(BuildContext context) {
    // This is used to detect the cursor position, in the case where
    // auto scrolling is engaged by middle mouse click rather than
    // middle mouse click+drag.
    return MouseRegion(
      onHover: (event) {
        if (isScrolling && startOffset != null) {
          widget.onMouseMoved?.call(startOffset!, event.position);
        }
      },
      child: Listener(
        onPointerDown: (event) {
          if (isScrolling) {
            setState(() => isScrolling = false);
            return widget.onEndScrolling?.call();
          }

          if (event.buttons != 4) return;

          pointerTime = DateTime.now().millisecondsSinceEpoch;
          setState(() {
            isScrolling = true;
            startOffset = event.position;
          });
          widget.onStartScrolling?.call(event.position);
        },
        onPointerUp: (event) {
          if (pointerTime + 500 < DateTime.now().millisecondsSinceEpoch) {
            setState(() => isScrolling = false);
            widget.onEndScrolling?.call();
          }
        },
        onPointerMove: (event) {
          if (event.buttons != 4 || !isScrolling || startOffset == null) return;

          widget.onMouseMoved?.call(startOffset!, event.position);
        },
        child: widget.child,
      ),
    );
  }
}
