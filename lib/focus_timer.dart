import 'package:flutter/material.dart';
import 'dart:async';

class MyStopwatch extends Stopwatch {
  int offsetSeconds = 0;

  MyStopwatch({this.offsetSeconds = 0});

  @override
  Duration get elapsed {
    return super.elapsed + Duration(seconds: offsetSeconds);
  }

  @override
  int get elapsedMilliseconds {
    return elapsed.inMilliseconds;
  }

  int get elapsedSeconds {
    return elapsed.inSeconds;
  }

  int get days {
    return elapsed.inDays;
  }

  int get hours {
    return elapsed.inHours % 24;
  }

  int get minutes {
    return elapsed.inMinutes % 60;
  }

  int get seconds {
    return elapsed.inSeconds % 60;
  }

  void setTime({int seconds = 0}) {
    offsetSeconds = seconds;
  }

  void addTime({int seconds = 0}) {
    offsetSeconds += seconds;
  }

  @override
  reset() {
    setTime(seconds: 0);
    super.reset();
  }

  @override
  String toString() {
    return "${days.toString().padLeft(2, '0')}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
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
              stopwatch.toString(),
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
                stopwatch.reset();
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
