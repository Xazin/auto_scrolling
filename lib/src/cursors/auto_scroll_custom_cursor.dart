import 'package:auto_scrolling/auto_scrolling.dart';
import 'package:flutter/material.dart';

/// A function that returns a Widget to display as a Cursor.
///
typedef CursorBuilder = Widget? Function(AutoScrollDirection direction);

/// Used to display a custom cursor while auto scrolling.
///
/// Must be a child of a [Stack] widget.
///
class AutoScrollCustomCursor extends StatelessWidget {
  /// Creates an [AutoScrollCustomCursor].
  ///
  const AutoScrollCustomCursor({
    super.key,
    required this.parentKey,
    required this.cursorOffset,
    required this.direction,
    required this.cursorBuilder,
  });

  /// The key of the parent widget.
  ///
  final GlobalKey parentKey;

  /// The offset of the cursor relative to parent.
  ///
  final Offset cursorOffset;

  /// The direction of the auto-scrolling.
  ///
  final AutoScrollDirection direction;

  /// A function that returns a Widget to display as a Cursor.
  ///
  final CursorBuilder cursorBuilder;

  @override
  Widget build(BuildContext context) {
    final localOffset = getCursorOffset();
    return Positioned(
      left: localOffset.dx,
      top: localOffset.dy,
      child: IgnorePointer(
        child: FractionalTranslation(
          translation: const Offset(-0.5, -0.5),
          child: cursorBuilder.call(direction),
        ),
      ),
    );
  }

  /// Returns the cursor offset relative to the parent widget.
  ///
  Offset getCursorOffset() {
    final renderBox =
        parentKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return Offset.zero;

    return renderBox.globalToLocal(cursorOffset);
  }
}
