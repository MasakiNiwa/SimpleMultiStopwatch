import 'package:flutter/material.dart';
import 'dart:async';
import 'package:simple_multi_stopwatch/editable_stopwatch.dart';

//ストップウォッチを一つ表示するためのWidget
// This widget is used to display a stopwatch.
class FocusTimer extends StatefulWidget {
  //FocusTimerの引数をFocusTimerStateに渡すためのプロパティ
  //Property for passing FocusTimer arguments to FocusTimerState.
  final int initialOffsetTime;
  final String initialText;
  final bool isRunning;
  final DateTime closeTime;
  //どのFocusTimerウィジェットなのか特定するためのUniqueKey
  //UniqueKey for identifying which FocusTimer widget this is.
  final timerKey = UniqueKey();

  //引数としてオフセット秒とメモの初期値を受け取ります
  //Constructor that takes initial offset time and initial text as arguments.
  FocusTimer(
      {super.key,
      this.initialOffsetTime = 0,
      this.initialText = "",
      this.isRunning = false,
      required this.closeTime});

  @override
  State<FocusTimer> createState() => FocusTimerState();
}

class FocusTimerState extends State<FocusTimer> with WidgetsBindingObserver {
  //Stopwatchクラスを拡張したEditableStopwatchクラスのインスタンスを作成してプロパティに格納します
  //Instance of the EditableStopwatch class, which extends the Stopwatch class, stored in a property.
  final EditableStopwatch stopwatch = EditableStopwatch();
  //ウィジェット表示を更新するためのTimerです
  //Timer for updating the widget display.
  Timer? timer;
  //メモを入力するTextFieldに紐づけるためのコントローラです
  //Controller for linking to the TextField where you enter a memo.
  final TextEditingController textController = TextEditingController();
  //ストップウォッチ動作時と停止時でウィジェットの外枠の色を切り替えるためのプロパティです
  //Property to switch the color of the widget border between running and stopped stopwatch.
  MaterialColor timerBorderColor = Colors.blueGrey;

  bool isPaused = false;
  DateTime pauseTime = DateTime.now();

  //initStateメソッドをオーバーライドします
  //まず、オフセット秒とメモの初期値を設定します
  //次に、ストップウォッチ動作中は100ミリ秒ごとにウィジェットを更新するように設定しています
  //Override the initState method.
  //First, set the initial offset time and initial text.
  //Next, set the widget to update every 100 milliseconds while the stopwatch is running.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    stopwatch.setOffsetTime(seconds: widget.initialOffsetTime);
    textController.text = widget.initialText;
    if (widget.isRunning) {
      stopwatch.addOffsetTime(
          seconds: DateTime.now().difference(widget.closeTime).inSeconds);
      startFocusTimer();
    }
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  //disposeメソッドをオーバーライドします
  //関連するインスタンスを停止します
  //Override the dispose method.
  //Stop related instances.
  @override
  void dispose() {
    stopwatch.stop();
    timer?.cancel();
    textController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //タイマーのライフサイクルを監視して、タイマーの状態を管理します
  //Monitor the timer's lifecycle and manage the timer's state.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (stopwatch.isRunning) {
        isPaused = true;
        pauseTime = DateTime.now();
        stopFocusTimer();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (isPaused) {
        stopwatch.addOffsetTime(
            seconds: DateTime.now().difference(pauseTime).inSeconds);
        startFocusTimer();
        isPaused = false;
      }
    }
  }

  //FoucsTimerウィジェットのストップウォッチを動かします
  //Starts the stopwatch of the FocusTimer widget.
  void startFocusTimer() {
    stopwatch.start();
    timerBorderColor = Colors.deepOrange;
  }

  //FoucsTimerウィジェットのストップウォッチを停止します
  //Stops the stopwatch of the FocusTimer widget.
  void stopFocusTimer() {
    stopwatch.stop();
    timerBorderColor = Colors.blueGrey;
  }

  //ストップウォッチウィジェットを構築します
  //Build the stopwatch widget.
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
                stopFocusTimer();
              } else {
                startFocusTimer();
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
          Container(width: 25),
        ],
      ),
    );
  }
}
