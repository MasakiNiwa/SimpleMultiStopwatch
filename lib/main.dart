import 'package:flutter/material.dart';
import 'dart:async';

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
  List<Widget> timers = [const FocusTimer()];
  void addTimer() {
    timers.add(const FocusTimer());
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

class FocusTimer extends StatefulWidget {
  const FocusTimer({super.key});

  @override
  State<FocusTimer> createState() => _FocusTimerState();
}

class _FocusTimerState extends State<FocusTimer> {
  final stopwatch = Stopwatch();
  String getTimeCount() {
    return stopwatch.elapsed.inDays.toString().padLeft(2, '0') +
        ":" +
        (stopwatch.elapsed.inHours % 24).toString().padLeft(2, '0') +
        ":" +
        (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
        ":" +
        (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
        "." +
        ((stopwatch.elapsed.inMilliseconds % 1000) ~/ 10)
            .toString()
            .padLeft(2, '0');
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(7),
        color: Colors.lightBlue[100],
      ),
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            getTimeCount(),
            style: const TextStyle(fontSize: 25),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                stopwatch.start();
              },
              child: const Icon(Icons.timer)),
          ElevatedButton(
              onPressed: () {
                stopwatch.stop();
              },
              child: const Icon(Icons.stop)),
          ElevatedButton(
              onPressed: () {
                stopwatch.reset();
              },
              child: const Icon(Icons.restart_alt)),
          const Spacer(),
        ],
      ),
    );
  }
}
