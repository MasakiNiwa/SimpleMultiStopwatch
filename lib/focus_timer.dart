import 'package:flutter/material.dart';
import 'dart:async';
import 'package:simple_multi_stopwatch/editable_stopwatch.dart';

//ストップウォッチを一つ表示するためのWidget
// This widget is used to display a stopwatch.
class FocusTimer extends StatefulWidget {
  static final List<Color> timerColorList = [
    const Color.fromRGBO(240, 240, 240, 1),
    Colors.red.shade100,
    Colors.indigo.shade100,
    Colors.grey.shade400,
    Colors.yellow.shade100,
    Colors.cyan.shade100,
    Colors.purple.shade100,
    Colors.lightGreen.shade100,
  ];

  //FocusTimerの引数をFocusTimerStateに渡すためのプロパティ
  //Property for passing FocusTimer arguments to FocusTimerState.
  final Duration initialOffsetTime;
  final String initialText;
  final bool isRunning;
  final DateTime closeTime;
  final int backgroundColorIndex;
  final Duration targetTime;
  //どのFocusTimerウィジェットなのか特定するためのUniqueKey
  //UniqueKey for identifying which FocusTimer widget this is.
  final timerKey = UniqueKey();

  //引数としてオフセット秒とメモの初期値を受け取ります
  //Constructor that takes initial offset time and initial text as arguments.
  FocusTimer(
      {super.key,
      this.initialOffsetTime = Duration.zero,
      this.initialText = "",
      this.isRunning = false,
      required this.closeTime,
      this.backgroundColorIndex = 0,
      this.targetTime = Duration.zero});

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
  //ストップウォッチispausedの状態に入っているかどうかと、停止した時間を保存するためのプロパティです
  //Property to indicate whether the stopwatch is paused and to store the time when it was paused.
  bool isPaused = false;
  DateTime pauseTime = DateTime.now();
  //
  int backgroundColorIndex = 0;
  Color backgroundColor = FocusTimer.timerColorList[0];
  //
  bool optionIsVisible = false;
  //
  Duration targetTime = Duration.zero;
  double get progress {
    if (targetTime.inSeconds == 0 || stopwatch.elapsed == Duration.zero) {
      return 0.0;
    } else {
      return stopwatch.elapsed.inSeconds / targetTime.inSeconds;
    }
  }

  //
  Timer? adjustTimer;

  //initStateメソッドをオーバーライドします
  //タイマーの初期状態を設定します
  //次に、ストップウォッチ動作中は50ミリ秒ごとにウィジェットを更新するように設定しています
  //Override the initState method.
  //Set the initial state of the timer.
  //Next, set the widget to update every 100 milliseconds while the stopwatch is running.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    stopwatch.setOffsetTime(widget.initialOffsetTime);
    textController.text = widget.initialText;
    backgroundColorIndex = widget.backgroundColorIndex;
    backgroundColor = FocusTimer.timerColorList[backgroundColorIndex];
    targetTime = widget.targetTime;

    if (widget.isRunning) {
      stopwatch.addOffsetTime(DateTime.now().difference(widget.closeTime));
      startFocusTimer();
    }
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
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
    adjustTimer?.cancel();
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
        stopwatch.addOffsetTime(DateTime.now().difference(pauseTime));
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

  void adjustTimerOnPressed({required Duration timespan}) {
    adjustTimer =
        Timer.periodic(const Duration(milliseconds: 100), (adjustTimer) {
      if (timespan > Duration.zero ||
          (timespan < Duration.zero && stopwatch.elapsed >= timespan.abs())) {
        stopwatch.addOffsetTime(timespan);
        setState(() {});
      }
    });
  }

  void adjustTargetTimeOnPressed({required Duration timespan}) {
    adjustTimer =
        Timer.periodic(const Duration(milliseconds: 100), (adjustTimer) {
      if (timespan > Duration.zero ||
          (timespan < Duration.zero && targetTime >= timespan.abs())) {
        targetTime += timespan;
        setState(() {});
      }
    });
  }

  void resetFocusTimer() {
    stopwatch.stop();
    stopwatch.reset();
    timerBorderColor = Colors.blueGrey;
    setState(() {});
  }

  //ストップウォッチウィジェットを構築します
  //Build the stopwatch widget.
  @override
  Widget build(BuildContext context) {
    //画面サイズでフォントサイズ等を調整
    final Size widgetSize = MediaQuery.of(context).size;
    final double fontSizeL = widgetSize.width * 0.053;
    final double fontSizeM = fontSizeL * 18 / 25;
    final double fontSizeS = fontSizeL * 12 / 25;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: timerBorderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(7),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (stopwatch.isRunning) {
                    stopFocusTimer();
                  } else {
                    startFocusTimer();
                  }
                  setState(() {});
                },
                onVerticalDragEnd: (details) {
                  if ((optionIsVisible && details.primaryVelocity! < 0) ||
                      (!optionIsVisible && details.primaryVelocity! > 0)) {
                    optionIsVisible = !optionIsVisible;
                    setState(() {});
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      stopwatch.elapsed.inHours.toString().padLeft(4, '0'),
                      style: TextStyle(fontSize: fontSizeL),
                    ),
                    Text(
                      'h',
                      style: TextStyle(fontSize: fontSizeS),
                    ),
                    Text(
                      stopwatch.minutes.toString().padLeft(2, '0'),
                      style: TextStyle(fontSize: fontSizeL),
                    ),
                    Text(
                      'm',
                      style: TextStyle(fontSize: fontSizeS),
                    ),
                    Text(
                      stopwatch.seconds.toString().padLeft(2, '0'),
                      style: TextStyle(fontSize: fontSizeL),
                    ),
                    Text(
                      's',
                      style: TextStyle(fontSize: fontSizeS),
                    ),
                  ],
                ),
              ),
              Container(width: fontSizeS),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                  ),
                  onPressed: resetFocusTimer,
                  child: const Icon(Icons.restart_alt)),
              Container(width: fontSizeS),
              Flexible(
                child: TextField(
                  controller: textController,
                  enabled: true,
                  maxLines: 1,
                ),
              ),
              Container(width: fontSizeS),
            ],
          ),
          SizedBox(height: 3, child: LinearProgressIndicator(value: progress)),
          Visibility(
              visible: optionIsVisible,
              child: Column(
                children: [
                  Container(height: 7),
                  Row(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  stopwatch.addOffsetTime(
                                      const Duration(hours: 100));
                                  setState(() {});
                                },
                                onLongPressStart: (details) {
                                  adjustTimerOnPressed(
                                      timespan: const Duration(hours: 100));
                                },
                                onLongPressEnd: (details) {
                                  adjustTimer?.cancel();
                                },
                                child: Icon(
                                  Icons.double_arrow_sharp,
                                  size: fontSizeM,
                                  color: Colors.blue,
                                ),
                              ),
                              Container(height: 5),
                              GestureDetector(
                                onTap: () {
                                  stopwatch
                                      .addOffsetTime(const Duration(hours: 1));
                                  setState(() {});
                                },
                                onLongPressStart: (details) {
                                  adjustTimerOnPressed(
                                      timespan: const Duration(hours: 1));
                                },
                                onLongPressEnd: (details) {
                                  adjustTimer?.cancel();
                                },
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: fontSizeL,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'h',
                            style: TextStyle(fontSize: fontSizeM),
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (stopwatch.elapsed.inHours >= 100) {
                                    stopwatch.addOffsetTime(
                                        const Duration(hours: -100));
                                  }
                                  setState(() {});
                                },
                                onLongPressStart: (details) {
                                  adjustTimerOnPressed(
                                      timespan: const Duration(hours: -100));
                                },
                                onLongPressEnd: (details) {
                                  adjustTimer?.cancel();
                                },
                                child: Icon(
                                  Icons.double_arrow_sharp,
                                  size: fontSizeM,
                                  color: Colors.red,
                                ),
                              ),
                              Container(height: 5),
                              GestureDetector(
                                onTap: () {
                                  if (stopwatch.elapsed.inHours > 0) {
                                    stopwatch.addOffsetTime(
                                        const Duration(hours: -1));
                                  }
                                  setState(() {});
                                },
                                onLongPressStart: (details) {
                                  adjustTimerOnPressed(
                                      timespan: const Duration(hours: -1));
                                },
                                onLongPressEnd: (details) {
                                  adjustTimer?.cancel();
                                },
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: fontSizeL,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              stopwatch
                                  .addOffsetTime(const Duration(minutes: 1));
                              setState(() {});
                            },
                            onLongPressStart: (details) {
                              adjustTimerOnPressed(
                                  timespan: const Duration(minutes: 1));
                            },
                            onLongPressEnd: (details) {
                              adjustTimer?.cancel();
                            },
                            child: Icon(
                              Icons.arrow_drop_up,
                              size: fontSizeL,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'm',
                            style: TextStyle(fontSize: fontSizeM),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (stopwatch.elapsed.inMinutes > 0) {
                                stopwatch
                                    .addOffsetTime(const Duration(minutes: -1));
                              }
                              setState(() {});
                            },
                            onLongPressStart: (details) {
                              adjustTimerOnPressed(
                                  timespan: const Duration(minutes: -1));
                            },
                            onLongPressEnd: (details) {
                              adjustTimer?.cancel();
                            },
                            child: Icon(
                              Icons.arrow_drop_down,
                              size: fontSizeL,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              stopwatch
                                  .addOffsetTime(const Duration(seconds: 1));
                              setState(() {});
                            },
                            onLongPressStart: (details) {
                              adjustTimerOnPressed(
                                  timespan: const Duration(seconds: 1));
                            },
                            onLongPressEnd: (details) {
                              adjustTimer?.cancel();
                            },
                            child: Icon(
                              Icons.arrow_drop_up,
                              size: fontSizeL,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            's',
                            style: TextStyle(fontSize: fontSizeM),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (stopwatch.elapsed.inSeconds > 0) {
                                stopwatch
                                    .addOffsetTime(const Duration(seconds: -1));
                              }
                              setState(() {});
                            },
                            onLongPressStart: (details) {
                              adjustTimerOnPressed(
                                  timespan: const Duration(seconds: -1));
                            },
                            onLongPressEnd: (details) {
                              adjustTimer?.cancel();
                            },
                            child: Icon(
                              Icons.arrow_drop_down,
                              size: fontSizeL,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.timer_sharp,
                        color: Colors.redAccent,
                        size: fontSizeM,
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          targetTime = Duration.zero;
                          setState(() {});
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              targetTime.inHours.toString().padLeft(4, '0'),
                              style: TextStyle(fontSize: fontSizeM),
                            ),
                            Text(
                              'h',
                              style: TextStyle(fontSize: fontSizeS),
                            ),
                            Text(
                              (targetTime.inMinutes % 60)
                                  .toString()
                                  .padLeft(2, '0'),
                              style: TextStyle(fontSize: fontSizeM),
                            ),
                            Text(
                              'm',
                              style: TextStyle(fontSize: fontSizeS),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      targetTime += const Duration(hours: 100);
                                      setState(() {});
                                    },
                                    onLongPressStart: (details) {
                                      adjustTargetTimeOnPressed(
                                          timespan: const Duration(hours: 100));
                                    },
                                    onLongPressEnd: (details) {
                                      adjustTimer?.cancel();
                                    },
                                    child: Icon(
                                      Icons.double_arrow_sharp,
                                      size: fontSizeM,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Container(height: 5),
                                  GestureDetector(
                                    onTap: () {
                                      targetTime += const Duration(hours: 1);
                                      setState(() {});
                                    },
                                    onLongPressStart: (details) {
                                      adjustTargetTimeOnPressed(
                                          timespan: const Duration(hours: 1));
                                    },
                                    onLongPressEnd: (details) {
                                      adjustTimer?.cancel();
                                    },
                                    child: Icon(
                                      Icons.arrow_drop_up,
                                      size: fontSizeL,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'h',
                                style: TextStyle(fontSize: fontSizeM),
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (targetTime.inHours >= 100) {
                                        targetTime -=
                                            const Duration(hours: 100);
                                      }
                                      setState(() {});
                                    },
                                    onLongPressStart: (details) {
                                      adjustTargetTimeOnPressed(
                                          timespan:
                                              const Duration(hours: -100));
                                    },
                                    onLongPressEnd: (details) {
                                      adjustTimer?.cancel();
                                    },
                                    child: Icon(
                                      Icons.double_arrow_sharp,
                                      size: fontSizeM,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Container(height: 5),
                                  GestureDetector(
                                    onTap: () {
                                      if (targetTime.inHours > 0) {
                                        targetTime -= const Duration(hours: 1);
                                      }
                                      setState(() {});
                                    },
                                    onLongPressStart: (details) {
                                      adjustTargetTimeOnPressed(
                                          timespan: const Duration(hours: -1));
                                    },
                                    onLongPressEnd: (details) {
                                      adjustTimer?.cancel();
                                    },
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      size: fontSizeL,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  targetTime += const Duration(minutes: 1);
                                  setState(() {});
                                },
                                onLongPressStart: (details) {
                                  adjustTargetTimeOnPressed(
                                      timespan: const Duration(minutes: 1));
                                },
                                onLongPressEnd: (details) {
                                  adjustTimer?.cancel();
                                },
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: fontSizeL,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                'm',
                                style: TextStyle(fontSize: fontSizeM),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (targetTime.inMinutes > 0) {
                                    targetTime -= const Duration(minutes: 1);
                                  }
                                  setState(() {});
                                },
                                onLongPressStart: (details) {
                                  adjustTargetTimeOnPressed(
                                      timespan: const Duration(minutes: -1));
                                },
                                onLongPressEnd: (details) {
                                  adjustTimer?.cancel();
                                },
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: fontSizeL,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
