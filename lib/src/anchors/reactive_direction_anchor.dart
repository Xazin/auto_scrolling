import 'package:auto_scrolling/src/anchors/triangle_painter.dart';
import 'package:auto_scrolling/src/utils.dart';
import 'package:flutter/material.dart';

/// Renders an anchor that displays a circle with a triangle in each
/// scrollable direction. The visible triangles is determined by
/// the [horizontalController] and [verticalController] properties.
///
/// This anchor greys out (reduces opacity) the triangles that are not
/// scrollable in the respective direction.
///
/// For an anchor that doesn't grey out the triangles, use either
/// MultiDirectionAnchor or SingleDirectionAnchor.
///
class ReactiveDirectionAnchor extends StatefulWidget {
  /// Creates a [ReactiveDirectionAnchor].
  ///
  const ReactiveDirectionAnchor({
    super.key,
    this.horizontalController,
    this.verticalController,
  }) : assert(
          verticalController != null || horizontalController != null,
          'At least one scroll controller must be provided.',
        );

  /// The horizontal scroll controller.
  /// If provided, the horizontal triangle will be visible when
  /// the scrollable content is horizontally scrollable.
  ///
  final ScrollController? horizontalController;

  /// The vertical scroll controller.
  /// If provided, the vertical triangle will be visible when
  /// the scrollable content is vertically scrollable.
  ///
  final ScrollController? verticalController;

  @override
  State<ReactiveDirectionAnchor> createState() =>
      _ReactiveDirectionAnchorState();
}

class _ReactiveDirectionAnchorState extends State<ReactiveDirectionAnchor> {
  final Set<AutoScrollDirection> _directions = {};

  @override
  void initState() {
    _checkDirections();
    widget.horizontalController?.addListener(_update);
    widget.verticalController?.addListener(_update);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ReactiveDirectionAnchor oldWidget) {
    oldWidget.horizontalController?.removeListener(_update);
    oldWidget.verticalController?.removeListener(_update);
    widget.horizontalController?.addListener(_update);
    widget.verticalController?.addListener(_update);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.horizontalController?.removeListener(_update);
    widget.verticalController?.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (mounted) {
      setState(_checkDirections);
    }
  }

  void _checkDirections() {
    _directions.clear();
    if (widget.horizontalController != null) {
      if (widget.horizontalController!.offset > 0) {
        _directions.add(AutoScrollDirection.left);
      }

      if (widget.horizontalController!.position.maxScrollExtent >
          widget.horizontalController!.offset) {
        _directions.add(AutoScrollDirection.right);
      }
    }

    if (widget.verticalController != null) {
      if (widget.verticalController!.offset > 0) {
        _directions.add(AutoScrollDirection.up);
      }

      if (widget.verticalController!.position.maxScrollExtent >
          widget.verticalController!.offset) {
        _directions.add(AutoScrollDirection.down);
      }
    }
  }

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
        child: Stack(
          children: [
            Positioned(
              child: Center(
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (widget.verticalController != null)
              Positioned(
                top: 3,
                left: 0,
                right: 0,
                child: Center(
                  child: Opacity(
                    opacity:
                        _directions.contains(AutoScrollDirection.up) ? 1 : 0.5,
                    child: const CustomPaint(
                      painter: TrianglePainter(),
                      size: Size(5, 3),
                    ),
                  ),
                ),
              ),
            if (widget.verticalController != null)
              Positioned(
                bottom: 3,
                left: 0,
                right: 0,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Opacity(
                      opacity: _directions.contains(AutoScrollDirection.down)
                          ? 1
                          : 0.5,
                      child: const CustomPaint(
                        painter: TrianglePainter(),
                        size: Size(5, 3),
                      ),
                    ),
                  ),
                ),
              ),
            if (widget.horizontalController != null)
              Positioned(
                left: 3,
                top: 0,
                bottom: 0,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Opacity(
                      opacity: _directions.contains(AutoScrollDirection.left)
                          ? 1
                          : 0.5,
                      child: const CustomPaint(
                        painter: TrianglePainter(),
                        size: Size(5, 3),
                      ),
                    ),
                  ),
                ),
              ),
            if (widget.horizontalController != null)
              Positioned(
                right: 3,
                top: 0,
                bottom: 0,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Opacity(
                      opacity: _directions.contains(AutoScrollDirection.right)
                          ? 1
                          : 0.5,
                      child: const CustomPaint(
                        painter: TrianglePainter(),
                        size: Size(5, 3),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
