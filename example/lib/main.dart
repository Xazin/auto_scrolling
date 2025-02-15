import 'package:auto_scrolling/auto_scrolling.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Scroll Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Auto Scroll Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController controller = ScrollController();
  bool isVertical = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Row(
            children: [
              Text(isVertical ? 'Vertical' : 'Horizontal'),
              const SizedBox(width: 4),
              Switch(
                value: isVertical,
                onChanged: (value) => setState(() => isVertical = value),
              ),
            ],
          ),
        ],
      ),
      body: AutoScroll(
        controller: controller,
        scrollDirection: Axis.vertical,
        child: TwoDimensionalScrollWidget(
          verticalController: controller,
          horizontalController: ScrollController(),
          child: Column(
            children: [
              for (int i = 0; i < 10; i++)
                Container(
                  height: 5000,
                  width: 5000,
                  color: colorForIndex(i),
                ),
            ],
          ),
        ),
        // ListView.builder(
        //   controller: controller,
        //   scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
        //   itemCount: 100,
        //   itemBuilder: (_, index) => Container(
        //     height: isVertical ? 500 : double.infinity,
        //     width: isVertical ? double.infinity : 500,
        //     color: colorForIndex(index),
        //   ),
        // ),
      ),
    );
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

class TwoDimensionalScrollWidget extends StatelessWidget {
  const TwoDimensionalScrollWidget({
    super.key,
    this.verticalController,
    this.horizontalController,
    required this.child,
  });

  final Widget child;
  final ScrollController? verticalController;
  final ScrollController? horizontalController;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
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
            child: child,
          ),
        ),
      ),
    );
  }
}
