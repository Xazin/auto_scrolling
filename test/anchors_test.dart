import 'package:auto_scrolling/src/anchors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Anchors tests', () {
    testWidgets('SingleDirectionAnchor does not block mouse events',
        (tester) async {
      var wasTapped = false;
      await tester.pumpWidget(
        _buildStack(
          TextButton(
            onPressed: () => wasTapped = true,
            child: const Text('Button'),
          ),
          const SingleDirectionAnchor(),
        ),
      );

      final center = tester.getCenter(find.byType(SingleDirectionAnchor));

      await tester.tapAt(center);
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });

    testWidgets('MultiDirectionAnchor does not block mouse events',
        (tester) async {
      var wasTapped = false;
      await tester.pumpWidget(
        _buildStack(
          TextButton(
            onPressed: () => wasTapped = true,
            child: const Text('Button'),
          ),
          const MultiDirectionAnchor(),
        ),
      );

      final center = tester.getCenter(find.byType(MultiDirectionAnchor));

      await tester.tapAt(center);
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });
  });
}

Widget _buildStack(Widget firstChild, Widget secondChild) {
  return MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: firstChild,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: secondChild,
          ),
        ],
      ),
    ),
  );
}
