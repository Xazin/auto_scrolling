import 'dart:math';

import 'package:flutter/material.dart';

/// Renders an anchor that displays a circle with two triangles pointing in
/// opposite directions. The direction of the triangles is determined by the
/// [direction] property.
///
class SingleDirectionAnchor extends StatelessWidget {
  /// Creates a [SingleDirectionAnchor].
  ///
  const SingleDirectionAnchor({
    super.key,
    this.direction = Axis.vertical,
    this.fillColor = Colors.white,
  });

  /// The direction of the anchor.
  ///
  /// Defaults to [Axis.vertical].
  ///
  final Axis direction;

  /// The fill color of the anchor, defaults to [Colors.white].
  ///
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 25,
        height: 25,
        transform:
            direction == Axis.horizontal ? Matrix4.rotationZ(pi / 2) : null,
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: .8),
          color: fillColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 3),
              child: CustomPaint(
                painter: _TrianglePainter(),
                size: Size(5, 3),
              ),
            ),
            Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: RotatedBox(
                quarterTurns: 2,
                child: CustomPaint(
                  painter: _TrianglePainter(),
                  size: Size(5, 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders an anchor that displays a circle with a triangle in each direction.
///
class MultiDirectionAnchor extends StatelessWidget {
  /// Creates a [SingleDirectionAnchor].
  ///
  const MultiDirectionAnchor({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: .8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 3),
              child: RotatedBox(
                quarterTurns: -1,
                child: CustomPaint(
                  painter: _TrianglePainter(),
                  size: Size(5, 3),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: CustomPaint(
                    painter: _TrianglePainter(),
                    size: Size(5, 3),
                  ),
                ),
                Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: CustomPaint(
                      painter: _TrianglePainter(),
                      size: Size(5, 3),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 3),
              child: RotatedBox(
                quarterTurns: 1,
                child: CustomPaint(
                  painter: _TrianglePainter(),
                  size: Size(5, 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    canvas.drawPath(getTrianglePath(size.width, size.height), fillPaint);
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
  bool shouldRepaint(_TrianglePainter oldDelegate) => false;
}
