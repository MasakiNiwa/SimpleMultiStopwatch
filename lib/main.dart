import 'package:flutter/material.dart';
import 'package:simple_multi_stopwatch/tab_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
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
  int tabCount = 7;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      panEnabled: true,
      minScale: 1.0,
      maxScale: 2.0,
      child: DefaultTabController(
        length: tabCount,
        child: Scaffold(
          appBar: AppBar(
            title: null,
            toolbarHeight: 0,
            backgroundColor: Colors.black,
            bottom: TabBar(
              tabs: [
                for (int i = 0; i < tabCount; i++) Tab(text: '${i + 1}'),
              ],
              labelColor: Colors.white,
              indicatorColor: Colors.pink,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
            ),
          ),
          body: TabBarView(
            children: [
              for (int i = 0; i < tabCount; i++) TabPage(pageIndex: i),
            ],
          ),
        ),
      ),
    );
  }
}
