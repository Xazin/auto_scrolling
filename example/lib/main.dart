import 'package:example/samples/multi_directional_scroll.dart';
import 'package:example/samples/single_direction_scroll.dart';
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
      home: const AppWidget(),
    );
  }
}

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final ScrollController controller = ScrollController();
  bool isVertical = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget currentSample = const SingleDirectionScrollSample();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentSample is SingleDirectionScrollSample
              ? 'Single Direction Scroll'
              : 'Multi Directional Scroll',
        ),
      ),
      drawer: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'Auto scroll examples',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: Colors.white),
                ),
              ),
            ),
            ListTile(
              title: const Text('Single Direction Scroll'),
              onTap: () {
                setState(
                  () => currentSample = const SingleDirectionScrollSample(),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Multi Directional Scroll'),
              onTap: () {
                setState(
                  () => currentSample = const MultiDirectionalScrollSample(),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: currentSample,
    );
  }
}
