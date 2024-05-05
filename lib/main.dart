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
  void addTimer() {
    timers.add(FocusTimer());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            ('Simple Multi Stopwatch :  ' +
                timers.length.toString() +
                ' timers'),
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
        child: ListView.builder(
            itemCount: timers.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: timers[index].timerKey,
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  setState(() {
                    timers.removeAt(index);
                  });
                },
                background: Container(
                    color: Colors.red,
                    child: const Row(children: [Icon(Icons.delete), Spacer()])),
                child: Card(
                  elevation: 3,
                  child: timers[index],
                ),
              );
            }),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: addTimer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
