import 'package:auto_scrolling/src/anchors/triangle_painter.dart';
import 'package:flutter/material.dart';

/// Renders an anchor that displays a circle with a triangle in each direction.
///
class MultiDirectionAnchor extends StatelessWidget {
  /// Creates a [MultiDirectionAnchor].
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
                  painter: TrianglePainter(),
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
                    painter: TrianglePainter(),
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
                      painter: TrianglePainter(),
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
                  painter: TrianglePainter(),
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
