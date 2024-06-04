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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int tabCount = 1;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabCount, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {}
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
              controller: _tabController,
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
            controller: _tabController,
            children: const [
              TabPage(),
            ],
          ),
        ),
      ),
    );
  }
}
