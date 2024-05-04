import 'package:flutter/material.dart';
import 'dart:async';

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
        " ";
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      if (stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  MaterialColor timercolor = Colors.blueGrey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: timercolor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          InkWell(
            child: Text(
              getTimeCount(),
              style: const TextStyle(fontSize: 25),
            ),
            onTap: () {
              if (stopwatch.isRunning) {
                stopwatch.stop();
                timercolor = Colors.blueGrey;
              } else {
                stopwatch.start();
                timercolor = Colors.deepOrange;
              }
              setState(() {});
            },
          ),
          ElevatedButton(
              onPressed: () {
                stopwatch.reset();
                setState(() {});
              },
              child: const Icon(Icons.restart_alt)),
          const Text('　'),
          const Flexible(
            child: TextField(
              //maxLength: 10,
              enabled: true,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
