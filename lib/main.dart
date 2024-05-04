import 'package:flutter/material.dart';
import 'package:simple_multi_stopwatch/focus_timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> timers = [];
  void addTimer() {
    timers.add(
        Dismissible(key: Key(timers.toString()), child: const FocusTimer()));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: timers,
        ),
      ),
      floatingActionButton:
          ElevatedButton(onPressed: addTimer, child: const Icon(Icons.add)),
    );
  }
}
