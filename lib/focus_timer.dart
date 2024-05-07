import 'package:flutter/material.dart';
import 'dart:async';

class MyStopwatch extends Stopwatch {
  int addSeconds = 0;

  MyStopwatch({this.addSeconds = 0});

  void setTime(int secTime) {
    addSeconds = secTime;
  }

  int getTime() {
    Duration totalTime;
    totalTime = super.elapsed + Duration(seconds: addSeconds);
    return totalTime.inSeconds;
  }

  @override
  reset() {
    setTime(0);
    super.reset();
  }

  String getTimeString() {
    Duration totalTime;
    totalTime = super.elapsed + Duration(seconds: addSeconds);
    return totalTime.inDays.toString().padLeft(2, '0') +
        ":" +
        (totalTime.inHours % 24).toString().padLeft(2, '0') +
        ":" +
        (totalTime.inMinutes % 60).toString().padLeft(2, '0') +
        ":" +
        (totalTime.inSeconds % 60).toString().padLeft(2, '0') +
        " ";
  }
}

class FocusTimer extends StatefulWidget {
  FocusTimer({super.key});
  final timerKey = UniqueKey();

  @override
  State<FocusTimer> createState() => FocusTimerState();
}

class FocusTimerState extends State<FocusTimer> {
  final stopwatch = MyStopwatch();
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
              stopwatch.getTimeString(),
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
