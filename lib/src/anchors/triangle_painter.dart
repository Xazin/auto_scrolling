import 'package:flutter/material.dart';

/// Renders a Triangle shape, pointing upwards
///
class TrianglePainter extends CustomPainter {
  /// Creates a [TrianglePainter]
  ///
  const TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    canvas.drawPath(_getTrianglePath(size.width, size.height), fillPaint);
  }

  Path _getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y)
      ..close();
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;
}
