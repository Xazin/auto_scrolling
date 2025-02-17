import 'package:auto_scrolling/src/utils.dart';
import 'package:flutter/material.dart';

/// A function that returns a Widget to display as a Cursor.
///
typedef CursorBuilder = Widget? Function(
  bool isMoving,
  AutoScrollDirection direction,
);

/// Used to display a custom cursor while auto scrolling.
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
          child: cursorBuilder.call(false, direction),
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

/// Draws a simple upwards-directed arrow.
///
class UpDirectionArrow extends StatelessWidget {
  /// Creates a [UpDirectionArrow].
  ///
  const UpDirectionArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size(12, 6),
      painter: _UpDirectionArrowPainter(),
    );
  }
}

class _UpDirectionArrowPainter extends CustomPainter {
  const _UpDirectionArrowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(_UpDirectionArrowPainter oldDelegate) => false;
}
