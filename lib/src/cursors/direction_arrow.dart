import 'dart:math' as math;

import 'package:auto_scrolling/auto_scrolling.dart';
import 'package:flutter/material.dart';

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
