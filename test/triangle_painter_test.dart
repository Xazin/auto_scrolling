import 'package:auto_scrolling/src/anchors/triangle_painter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrianglePainter', () {
    test('shouldRepaint always false', () {
      const painter = TrianglePainter();
      const oldDelegate = TrianglePainter();
      expect(painter.shouldRepaint(oldDelegate), false);
    });
  });
}
