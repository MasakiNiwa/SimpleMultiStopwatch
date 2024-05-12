import 'package:flutter/material.dart';
import 'dart:async';
import 'package:simple_multi_stopwatch/editable_stopwatch.dart';

//ストップウォッチを一つ表示するためのWidget
// This widget is used to display a stopwatch.
class FocusTimer extends StatefulWidget {
  final int initialOffsetTime;
  final String initialText;
  final timerKey = UniqueKey();

  FocusTimer({super.key, this.initialOffsetTime = 0, this.initialText = ""});

  @override
  State<FocusTimer> createState() => FocusTimerState();
}

class FocusTimerState extends State<FocusTimer> with WidgetsBindingObserver {
  final EditableStopwatch stopwatch = EditableStopwatch();
  Timer? timer;
  final TextEditingController textController = TextEditingController();
  MaterialColor timerBorderColor = Colors.blueGrey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    stopwatch.offsetSeconds = widget.initialOffsetTime;
    textController.text = widget.initialText;
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: timerBorderColor,
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
                timerBorderColor = Colors.blueGrey;
              } else {
                stopwatch.start();
                timerBorderColor = Colors.deepOrange;
              }
              setState(() {});
            },
          ),
          Container(width: 10),
          ElevatedButton(
              onPressed: () {
                stopwatch.stop();
                stopwatch.reset();
                timerBorderColor = Colors.blueGrey;
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
