import 'dart:math' as math;

import 'package:auto_scrolling/src/utils.dart';
import 'package:flutter/material.dart';

/// A function that returns a Widget to display as a Cursor.
///
typedef CursorBuilder = Widget? Function(AutoScrollDirection direction);

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

/// Draws an arrow pointing in [direction].
///
class DirectionArrow extends StatelessWidget {
  /// Creates a [DirectionArrow].
  ///
  const DirectionArrow({
    super.key,
    this.direction = AutoScrollDirection.up,
  });

  /// The direction of the arrow.
  ///
  final AutoScrollDirection direction;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _getRotationAngle(direction),
      child: const CustomPaint(
        size: Size(12, 6),
        painter: _UpDirectionArrowPainter(),
      ),
    );
  }

  /// Returns the rotation angle in radians based on the direction.
  double _getRotationAngle(AutoScrollDirection direction) =>
      switch (direction) {
        AutoScrollDirection.up => 0,
        AutoScrollDirection.upAndRight => math.pi / 4,
        AutoScrollDirection.upAndLeft => -math.pi / 4,
        AutoScrollDirection.down => math.pi,
        AutoScrollDirection.downAndRight => 3 * math.pi / 4,
        AutoScrollDirection.downAndLeft => -3 * math.pi / 4,
        AutoScrollDirection.right => math.pi / 2,
        AutoScrollDirection.left => -math.pi / 2,
        AutoScrollDirection.none => 0,
      };
}

class _UpDirectionArrowPainter extends CustomPainter {
  const _UpDirectionArrowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    canvas
      ..drawPath(getTrianglePath(size.width, size.height), borderPaint)
      ..drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y)
      ..close();
  }

  @override
  bool shouldRepaint(_UpDirectionArrowPainter oldDelegate) => false;
}
