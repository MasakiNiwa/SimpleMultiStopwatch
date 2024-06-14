import 'package:flutter/material.dart';
import 'package:simple_multi_stopwatch/tab_page.dart';
import 'package:simple_multi_stopwatch/data_storage_facade.dart';

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
  int tabCount = 7;
  late TabController _tabController;
  final DataStorageFacade dataStorageFacade = DataStorageFacade();

  Future<void> saveActivePage() async {
    await dataStorageFacade.setInt('active_tab_index', _tabController.index);
  }

  Future<void> loadActivePage() async {
    _tabController.index = await dataStorageFacade.getInt('active_tab_index');
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabCount, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadActivePage();
      _tabController.addListener(() {
        if (_tabController.indexIsChanging) {
          saveActivePage();
        }
      });
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
              tabs: [
                for (int i = 0; i < tabCount; i++) Tab(text: '${i + 1}'),
              ],
              controller: _tabController,
              labelColor: Colors.white,
              indicatorColor: Colors.pink,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (int i = 0; i < tabCount; i++) TabPage(pageIndex: i),
            ],
          ),
        ),
      ),
    );
  }
}
