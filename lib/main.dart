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
  final List<FocusTimer> timers = [];
  final List<GlobalObjectKey<FocusTimerState>> globalTimerKeys = [];
  void addTimer() {
    FocusTimer atimer = FocusTimer();
    timers.add(atimer);
    globalTimerKeys.add(GlobalObjectKey(atimer));
    setState(() {});
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
              setState(() {});
            },
            child: const Icon(Icons.delete_sweep),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          timers.clear();
          setState(() {});
        },
        child: ReorderableListView.builder(
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
                child: FocusTimer(key: globalTimerKeys[index]),
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
          },
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: addTimer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
