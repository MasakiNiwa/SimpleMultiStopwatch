import 'package:flutter/material.dart';
import 'dart:async';
import 'package:simple_multi_stopwatch/editable_stopwatch.dart';

//ストップウォッチを一つ表示するためのWidget
// This widget is used to display a stopwatch.
class FocusTimer extends StatefulWidget {
  FocusTimer({super.key});
  final timerKey = UniqueKey();

  @override
  State<FocusTimer> createState() => FocusTimerState();
}

class FocusTimerState extends State<FocusTimer> {
  final stopwatch = EditableStopwatch();
  Timer? timer;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    stopwatch.stop();
    timer?.cancel();
    textController.dispose();
    super.dispose();
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
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          InkWell(
            child: Text(
              stopwatch.timeToString(),
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
          Container(width: 10),
          ElevatedButton(
              onPressed: () {
                stopwatch.stop();
                stopwatch.reset();
                timercolor = Colors.blueGrey;
                setState(() {});
              },
              child: const Icon(Icons.restart_alt)),
          Container(width: 10),
          Flexible(
            child: TextField(
              controller: textController,
              enabled: true,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
