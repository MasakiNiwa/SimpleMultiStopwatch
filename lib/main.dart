import 'package:flutter/material.dart';
import 'package:simple_multi_stopwatch/focus_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<FocusTimer> timers = [];
  final List<GlobalObjectKey<FocusTimerState>> globalTimerKeys = [];
  List<String> timerOffsetList = [];
  List<String> timerMemoList = [];

  void addTimer() {
    FocusTimer timer = FocusTimer();
    timers.add(timer);
    globalTimerKeys.add(GlobalObjectKey(timer));
    timerOffsetList.add("0");
    timerMemoList.add("");
    setState(() {});
  }

  Future<void> restoreState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    timerOffsetList = prefs.getStringList('timer_offset_list') ?? [];
    timerMemoList = prefs.getStringList('timer_memo_list') ?? [];

    timers.clear();
    globalTimerKeys.clear();
    for (int i = 0; i < timerMemoList.length; i++) {
      FocusTimer timer = FocusTimer();
      timers.add(timer);
      globalTimerKeys.add(GlobalObjectKey(timer));
    }
    setState(() {});
  }

  Future<void> saveState() async {
    timerOffsetList = [];
    timerMemoList = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (globalTimerKeys.isNotEmpty) {
      for (int i = 0; i < globalTimerKeys.length; i++) {
        int offset =
            globalTimerKeys[i].currentState?.stopwatch.elapsedSeconds ?? 0;
        timerOffsetList.add(offset.toString());
        String text =
            globalTimerKeys[i].currentState?.textController.text ?? '';
        timerMemoList.add(text);
      }
    }
    await prefs.setStringList('timer_offset_list', timerOffsetList);
    await prefs.setStringList('timer_memo_list', timerMemoList);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    restoreState();
  }

  @override
  void dispose() {
    saveState();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        // await saveState();
        break;
      case AppLifecycleState.inactive:
        await saveState();
        break;
      case AppLifecycleState.paused:
        // await saveState();
        break;
      case AppLifecycleState.hidden:
        // await saveState();
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            ('Simple Multi Stopwatch :  ${timers.length.toString()} timers'),
            style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.lightBlue[100],
        actions: [
          ElevatedButton(
            onPressed: () {
              timers.clear();
              globalTimerKeys.clear();
              timerOffsetList.clear();
              timerMemoList.clear();
              setState(() {});
            },
            child: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: timers.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: timers[index].timerKey,
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              setState(() {
                timers.removeAt(index);
                globalTimerKeys.removeAt(index);
              });
            },
            background: Container(
                color: Colors.red,
                child: const Row(children: [Icon(Icons.delete), Spacer()])),
            child: Card(
              elevation: 3,
              child: FocusTimer(
                key: globalTimerKeys[index],
                initialOffsetTime: int.parse(timerOffsetList[index]),
                initialText: timerMemoList[index],
              ),
            ),
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final GlobalObjectKey<FocusTimerState> itemKey =
              globalTimerKeys.removeAt(oldIndex);
          globalTimerKeys.insert(newIndex, itemKey);
          setState(() {});
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: addTimer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
