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
        scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
        child: ListView.builder(
          controller: controller,
          scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: 100,
          itemBuilder: (_, index) => Container(
            height: isVertical ? 500 : double.infinity,
            width: isVertical ? double.infinity : 500,
            color: colorForIndex(index),
          ),
        ),
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
