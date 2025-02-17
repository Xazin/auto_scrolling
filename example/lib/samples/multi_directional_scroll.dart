import 'dart:math';

import 'package:auto_scrolling/auto_scrolling.dart';
import 'package:flutter/material.dart';

class MultiDirectionalScrollSample extends StatefulWidget {
  const MultiDirectionalScrollSample({super.key});

  @override
  State<MultiDirectionalScrollSample> createState() =>
      _MultiDirectionalScrollSampleState();
}

class _MultiDirectionalScrollSampleState
    extends State<MultiDirectionalScrollSample> {
  final ScrollController verticalController = ScrollController();
  final ScrollController horizontalController = ScrollController();

  @override
  void dispose() {
    verticalController.dispose();
    horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiAxisAutoScroll(
      willUseCustomCursor: (direction) => switch (direction) {
        AutoScrollDirection.none => false,
        _ => true,
      },
      cursorBuilder: cursorBuilder,
      anchorBuilder: (context) => MultiDirectionAnchor(),
      verticalController: verticalController,
      horizontalController: horizontalController,
      child: Scrollbar(
        thickness: 12.0,
        trackVisibility: true,
        interactive: true,
        controller: verticalController,
        scrollbarOrientation: ScrollbarOrientation.right,
        thumbVisibility: true,
        child: Scrollbar(
          thickness: 12.0,
          trackVisibility: true,
          interactive: true,
          controller: horizontalController,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          thumbVisibility: true,
          notificationPredicate: (ScrollNotification notif) => notif.depth == 1,
          child: SingleChildScrollView(
            controller: verticalController,
            child: SingleChildScrollView(
              primary: false,
              controller: horizontalController,
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  for (var index = 0; index < 100; index++)
                    Container(
                      height: 500,
                      width: 50000,
                      color: colorForIndex(index),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? cursorBuilder(isMoving, direction) {
    return switch (direction) {
      AutoScrollDirection.down => RotatedBox(
          quarterTurns: 2,
          child: UpDirectionArrow(),
        ),
      AutoScrollDirection.up => UpDirectionArrow(),
      AutoScrollDirection.left => RotatedBox(
          quarterTurns: 3,
          child: UpDirectionArrow(),
        ),
      AutoScrollDirection.right => RotatedBox(
          quarterTurns: 1,
          child: UpDirectionArrow(),
        ),
      AutoScrollDirection.downAndLeft => Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(pi / 4 * 5),
          child: UpDirectionArrow(),
        ),
      AutoScrollDirection.downAndRight => Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(pi / 4 * 3),
          child: UpDirectionArrow(),
        ),
      AutoScrollDirection.upAndLeft => Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(-0.75),
          child: UpDirectionArrow(),
        ),
      AutoScrollDirection.upAndRight => Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(0.75),
          child: UpDirectionArrow(),
        ),
      _ => null,
    };
  }

  Color colorForIndex(int index) {
    if (index % 5 == 0) return Colors.blue;
    if (index % 5 == 1) return Colors.red;
    if (index % 5 == 2) return Colors.orange;
    if (index % 5 == 3) return Colors.green;
    if (index % 5 == 4) return Colors.purple;

    return Colors.black;
  }
}
