import 'package:flutter/material.dart';
import 'dart:async';
import 'package:simple_multi_stopwatch/focus_timer.dart';
import 'package:simple_multi_stopwatch/data_storage_facade.dart';
import 'package:simple_multi_stopwatch/markdown_viewer_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TabPage extends StatefulWidget {
  final int pageIndex;

  const TabPage({super.key, required this.pageIndex});

  @override
  State<TabPage> createState() => TabPageState();
}

class TabPageState extends State<TabPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  //タブページが保有するタイマーのリスト
  //List to store the FocusTimer objects maintained by the TabPage.
  final List<FocusTimer> timers = [];
  //タブページが保有するタイマーのGlobalObjectKeyのリスト
  //タイマーを特定するために使用します
  //List of GlobalObjectKey objects for each FocusTimer, used to identify timers.
  final List<GlobalObjectKey<FocusTimerState>> globalTimerKeys = [];
  //データ保存用にShared_Preferencesのラッパークラスをインスタンス化します
  //An instance of the DataStorageFacade class, which is a wrapper around Shared Preferences for data storage.
  final DataStorageFacade dataStorageFacade = DataStorageFacade();
  //
  int pageIndex = 0;
  //
  bool _showBottom = false;
  bool _timeModeOfAppbar = true;

  //タイマーの状態のリスト
  //アプリの状態保存と復元に使用します
  //List of timer states.
  //Used to save and restore the app state.
  List<Duration> timerOffsetList = [];
  List<String> timerMemoList = [];
  List<bool> timerIsRunningList = [];
  List<int> timerColorList = [];
  List<Duration> targetTimeList = [];
  DateTime closeTime = DateTime.now();

  Timer? timer;
  String totalTime = '0000:00:00';
  String averageTime = '0000:00:00';
  void changeTotalTime() {
    setState(() {
      Duration total = Duration.zero;
      Duration average = Duration.zero;
      for (int i = 0; i < globalTimerKeys.length; i++) {
        total +=
            globalTimerKeys[i].currentState?.stopwatch.elapsed ?? Duration.zero;
      }
      totalTime =
          "${total.inHours.toString().padLeft(4, '0')}:${(total.inMinutes % 60).toString().padLeft(2, '0')}:${(total.inSeconds % 60).toString().padLeft(2, '0')}";
      if (globalTimerKeys.isNotEmpty) {
        average = total * (1 / globalTimerKeys.length);
      } else {
        average = Duration.zero;
      }
      averageTime =
          "${average.inHours.toString().padLeft(4, '0')}:${(average.inMinutes % 60).toString().padLeft(2, '0')}:${(average.inSeconds % 60).toString().padLeft(2, '0')}";
    });
  }

  //追加ボタンが押されたときに呼び出すメソッド
  //FocusTimerのインスタンスと対応するGlobalObjectKeyを作成してリストに追加します
  //作成されるFocusTimerには何もない初期値が渡されるようにします
  //タイマーを追加したら画面を更新します
  //Method called when the Add button is pressed.
  //Creates a new FocusTimer instance and adds it to the lists.
  //Sets the initial values for the timer to 0 seconds and an empty memo.
  //Updates the UI after adding the timer.
  void addTimer() {
    FocusTimer timer = FocusTimer(closeTime: DateTime.now());
    timers.add(timer);
    globalTimerKeys.add(GlobalObjectKey(timer));
    timerOffsetList.add(Duration.zero);
    timerMemoList.add("");
    timerIsRunningList.add(false);
    timerColorList.add(0);
    targetTimeList.add(Duration.zero);
    setState(() {});
  }

  void clearTimers() {
    timers.clear();
    globalTimerKeys.clear();
    timerOffsetList.clear();
    timerMemoList.clear();
    timerIsRunningList.clear();
    timerColorList.clear();
    targetTimeList.clear();
    setState(() {});
  }

  void startTimers() {
    for (int i = 0; i < globalTimerKeys.length; i++) {
      globalTimerKeys[i].currentState?.startFocusTimer();
    }
  }

  void stopTimers() {
    for (int i = 0; i < globalTimerKeys.length; i++) {
      globalTimerKeys[i].currentState?.stopFocusTimer();
    }
  }

  void resetTimers() {
    for (int i = 0; i < globalTimerKeys.length; i++) {
      globalTimerKeys[i].currentState?.resetFocusTimer();
    }
  }

  void sortTimersByElapsedTime() {
    globalTimerKeys.sort((a, b) =>
        (b.currentState?.stopwatch.elapsed ?? Duration.zero)
            .compareTo((a.currentState?.stopwatch.elapsed ?? Duration.zero)));
  }

  void sortTimersByName() {
    globalTimerKeys.sort((a, b) => (a.currentState?.textController.text ?? "")
        .compareTo((b.currentState?.textController.text ?? "")));
  }

  void sortTimersByActive() {
    globalTimerKeys.sort((a, b) =>
        ((b.currentState?.stopwatch.isRunning ?? false) ? 1 : 0).compareTo(
            ((a.currentState?.stopwatch.isRunning ?? false) ? 1 : 0)));
  }

  void sortTimersByColor() {
    globalTimerKeys.sort((a, b) => (a.currentState?.backgroundColorIndex ?? 0)
        .compareTo((b.currentState?.backgroundColorIndex ?? 0)));
  }

  //保存済みのアプリの状態(保有しているタイマー)を復元するメソッド
  //Shared_PreferencesのラッパークラスであるData_Storage_Facadeを使用します
  //まず最初に、保存をしていたタイマーのオフセット秒とメモのリストを読み込みます
  //読み込んだリストの個数だけFocusTimerインスタンスを作成してタブページ保有リストに追加します
  //※実際にオフセット秒とメモをタイマーに設定するタイミングは、ReorderableListView.builderでWidgetを画面にのせるタイミングになります
  //Method to restore the saved app state (list of timers).
  //Uses the Data_Storage_Facade, a wrapper class for Shared_Preferences.
  //Initially, retrieves the list of saved timer offset seconds and memos.
  //Creates FocusTimer instances for each item in the retrieved list and adds them to the TabPage's list.
  //Note: The actual offset seconds and memos are set to the timers when the widgets are displayed on the screen using ReorderableListView.builder.
  Future<void> restoreState() async {
    timerOffsetList = await dataStorageFacade
        .getDurationList('timer_offset_list_page$pageIndex');
    timerMemoList =
        await dataStorageFacade.getStringList('timer_memo_list_page$pageIndex');
    timerIsRunningList = await dataStorageFacade
        .getBoolList('timer_isrunning_list_page$pageIndex');
    timerColorList =
        await dataStorageFacade.getIntList('timer_color_list_page$pageIndex');
    targetTimeList = await dataStorageFacade
        .getDurationList('timer_targettime_list_page$pageIndex');
    closeTime =
        await dataStorageFacade.getDateTime('timer_closetime_page$pageIndex');

    if (timerOffsetList.length != timerMemoList.length) {
      timerOffsetList = [];
      timerMemoList = [];
      timerIsRunningList = [];
      timerColorList = [];
      targetTimeList = [];
    } else if (timerOffsetList.length != timerIsRunningList.length) {
      timerOffsetList = [];
      timerMemoList = [];
      timerIsRunningList = [];
      timerColorList = [];
      targetTimeList = [];
    } else if (timerOffsetList.length != timerColorList.length) {
      timerOffsetList = [];
      timerMemoList = [];
      timerIsRunningList = [];
      timerColorList = [];
      targetTimeList = [];
    } else if (timerOffsetList.length != targetTimeList.length) {
      timerOffsetList = [];
      timerMemoList = [];
      timerIsRunningList = [];
      timerColorList = [];
      targetTimeList = [];
    }

    timers.clear();
    globalTimerKeys.clear();
    for (int i = 0; i < timerMemoList.length; i++) {
      FocusTimer timer = FocusTimer(closeTime: DateTime.now());
      timers.add(timer);
      globalTimerKeys.add(GlobalObjectKey(timer));
    }
    setState(() {});
  }

  //アプリの状態(保有しているタイマー)を保存するメソッド
  //Shared_PreferencesのラッパークラスであるData_Storage_Facadeを使用します
  //保存時点のタイマーのglobalTimerKeysのリストを使用して処理をおこないます
  //globalTimerKeysの個数だけfor文をまわして、それぞれのkeyからFocusTimerStateのプロパティにアクセスしてタイマーの状態を読み込みます
  //最後に、読み込んだタイマーの状態のリストを保存します
  //Method to save the app state (list of timers).
  //Uses the Data_Storage_Facade, a wrapper class for Shared_Preferences.
  //Operates using the globalTimerKeys list of timers at the time of saving.
  //Iterates through the globalTimerKeys list, accessing the FocusTimerState properties for each key to retrieve timer state information.
  //Finally, saves the retrieved list of timer state information.
  Future<void> saveState() async {
    timerOffsetList = [];
    timerMemoList = [];
    timerIsRunningList = [];
    timerColorList = [];
    targetTimeList = [];
    if (globalTimerKeys.isNotEmpty) {
      for (int i = 0; i < globalTimerKeys.length; i++) {
        Duration offset =
            globalTimerKeys[i].currentState?.stopwatch.elapsed ?? Duration.zero;
        timerOffsetList.add(offset);
        String text =
            globalTimerKeys[i].currentState?.textController.text ?? '';
        timerMemoList.add(text);
        int colorIndex =
            globalTimerKeys[i].currentState?.backgroundColorIndex ?? 0;
        timerColorList.add(colorIndex);
        Duration targetTime =
            globalTimerKeys[i].currentState?.targetTime ?? Duration.zero;
        targetTimeList.add(targetTime);
        bool isrunnning =
            globalTimerKeys[i].currentState?.stopwatch.isRunning ?? false;
        bool ispaused = globalTimerKeys[i].currentState?.isPaused ?? false;
        if (isrunnning || ispaused) {
          timerIsRunningList.add(true);
        } else {
          timerIsRunningList.add(false);
        }
      }
    }
    await dataStorageFacade.setDurationList(
        'timer_offset_list_page$pageIndex', timerOffsetList);
    await dataStorageFacade.setStringList(
        'timer_memo_list_page$pageIndex', timerMemoList);
    await dataStorageFacade.setBoolList(
        'timer_isrunning_list_page$pageIndex', timerIsRunningList);
    await dataStorageFacade.setIntList(
        'timer_color_list_page$pageIndex', timerColorList);
    await dataStorageFacade.setDurationList(
        'timer_targettime_list_page$pageIndex', targetTimeList);
    await dataStorageFacade.setDateTime(
        'timer_closetime_page$pageIndex', DateTime.now());
  }

  //initStateメソッドをオーバーライドします
  //アプリ起動時にデータが復元されるようにします
  //Overrides the initState method.
  //Initializes the state of the widget.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pageIndex = widget.pageIndex;
    restoreState();
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      changeTotalTime();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //アプリのライフサイクルを監視して、アプリの状態を管理します
  //非アクティブ(inactive)かバックグラウンド(paused)になった時に、アプリの状態を保存します
  //Method to handle app lifecycle changes.
  //Saves the app state when the app becomes inactive or paused.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      await saveState();
    }
  }

  //アプリのメインウィジェットを構築します
  //Scaffoldウィジェットを使用しています
  //(1)appBarプロパティにある削除ボタンで、全タイマーをクリア
  //(2)bodyプロパティでは、ReorderableListView.builderを使って、リストにあるタイマーを画面に表示
  //(3)floatingActionButtonプロパティにある追加ボタンで、新規タイマーを追加
  //Builds the main widget for the app.
  //Uses the Scaffold widget to provide a basic layout.
  //(1)AppBar with a title and a delete button.
  //(2)ReorderableListView to display the timers in a list.
  //(3)FloatingActionButton to add a new timer.
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Size screenSize = MediaQuery.of(context).size;

    double getFontSize() {
      double size;
      if (screenSize.width >= 410) {
        size = screenSize.width * 0.040;
      } else if (screenSize.width >= 360) {
        size = screenSize.width * 0.038;
      } else {
        size = screenSize.width * 0.034;
      }
      return size;
    }

    final double fontSize = getFontSize();

    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Licenses'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Simple Multi Stopwatch',
                applicationIcon:
                    Image.asset('assets/icon/icon.png', width: 50, height: 50),
              );
            },
          ),
          const MarkdownListTile(
              name: 'Privacy Policy', path: 'docs/privacy_policy.md'),
          const MarkdownListTile(name: 'Contributing', path: 'CONTRIBUTING.md'),
          const MarkdownListTile(name: 'Contributors', path: 'CONTRIBUTORS.md'),
        ],
      )),
      appBar: AppBar(
        title: Row(
          children: [
            Text(timers.length.toString(),
                style: TextStyle(
                    fontSize: fontSize,
                    color: const Color.fromRGBO(240, 240, 240, 1))),
            Icon(
              Icons.timer_sharp,
              color: Colors.cyanAccent,
              size: fontSize,
            ),
            TextButton(
                onPressed: () {
                  _timeModeOfAppbar = !_timeModeOfAppbar;
                },
                child: _timeModeOfAppbar
                    ? Text('  Total Time: $totalTime',
                        style: TextStyle(
                            fontSize: fontSize,
                            color: const Color.fromRGBO(240, 240, 240, 1)))
                    : Text('  Average Time: $averageTime',
                        style: TextStyle(
                            fontSize: fontSize,
                            color: const Color.fromRGBO(240, 240, 240, 1)))),
          ],
        ),
        backgroundColor: Colors.black,
        toolbarHeight: fontSize * 3,
        actions: [
          IconButton(
            onPressed: () {
              _showBottom = !_showBottom;
            },
            icon: _showBottom
                ? Icon(Icons.toggle_on, size: fontSize * 2)
                : Icon(Icons.toggle_off, size: fontSize * 2),
            color: Colors.white,
          ),
        ],
        bottom: _showBottom
            ? PreferredSize(
                preferredSize: Size.fromHeight(fontSize * 2.5),
                child: Container(
                  color: Colors.black,
                  height: fontSize * 2.5,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: sortTimersByActive,
                        icon: const Icon(Icons.moving_outlined),
                        color: Colors.deepOrange,
                        iconSize: fontSize,
                      ),
                      IconButton(
                        onPressed: sortTimersByElapsedTime,
                        icon: const Icon(Icons.access_time_sharp),
                        color: Colors.cyanAccent,
                        iconSize: fontSize,
                      ),
                      IconButton(
                        onPressed: sortTimersByName,
                        icon: const Icon(Icons.sort_by_alpha_sharp),
                        color: Colors.greenAccent,
                        iconSize: fontSize,
                      ),
                      IconButton(
                        onPressed: sortTimersByColor,
                        icon: const Icon(Icons.color_lens),
                        color: Colors.limeAccent,
                        iconSize: fontSize,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: startTimers,
                        icon: const Icon(Icons.play_arrow),
                        color: Colors.cyanAccent,
                        iconSize: fontSize,
                      ),
                      IconButton(
                        onPressed: stopTimers,
                        icon: const Icon(Icons.stop),
                        color: Colors.white,
                        iconSize: fontSize,
                      ),
                      IconButton(
                        onPressed: resetTimers,
                        icon: const Icon(Icons.restart_alt),
                        color: Colors.yellowAccent,
                        iconSize: fontSize,
                      ),
                      IconButton(
                        onPressed: clearTimers,
                        icon: const Icon(Icons.delete_sweep),
                        color: Colors.redAccent,
                        iconSize: fontSize,
                      ),
                    ],
                  ),
                ))
            : null,
      ),
      body: ReorderableListView.builder(
        shrinkWrap: true,
        itemCount: timers.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            key: timers[index].timerKey,
            startActionPane: ActionPane(
              extentRatio: 0.25,
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {
                setState(() {
                  timers.removeAt(index);
                  globalTimerKeys.removeAt(index);
                  timerOffsetList.removeAt(index);
                  timerMemoList.removeAt(index);
                  timerIsRunningList.removeAt(index);
                  timerColorList.removeAt(index);
                  targetTimeList.removeAt(index);
                });
              }),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      timers.removeAt(index);
                      globalTimerKeys.removeAt(index);
                      timerOffsetList.removeAt(index);
                      timerMemoList.removeAt(index);
                      timerIsRunningList.removeAt(index);
                      timerColorList.removeAt(index);
                      targetTimeList.removeAt(index);
                    });
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
            endActionPane: ActionPane(
              extentRatio: 0.5,
              motion: const ScrollMotion(),
              children: [
                for (int colorIndex = 0;
                    colorIndex < FocusTimer.timerColorList.length;
                    colorIndex++)
                  SlidableAction(
                    onPressed: (_) {
                      setState(() {
                        globalTimerKeys[index]
                            .currentState
                            ?.backgroundColorIndex = colorIndex;
                        globalTimerKeys[index].currentState?.backgroundColor =
                            FocusTimer.timerColorList[colorIndex];
                      });
                    },
                    backgroundColor: FocusTimer.timerColorList[colorIndex],
                    foregroundColor: FocusTimer.timerColorList[colorIndex],
                    icon: Icons.palette,
                  ),
              ],
            ),
            child: Card(
              elevation: 3,
              child: FocusTimer(
                key: globalTimerKeys[index],
                initialOffsetTime: timerOffsetList[index],
                initialText: timerMemoList[index],
                isRunning: timerIsRunningList[index],
                closeTime: closeTime,
                backgroundColorIndex: timerColorList[index],
                targetTime: targetTimeList[index],
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
      floatingActionButton: FloatingActionButton(
          heroTag: null, onPressed: addTimer, child: const Icon(Icons.add)),
    );
  }
}

class MarkdownListTile extends StatelessWidget {
  final String name;
  final String path;

  const MarkdownListTile({
    super.key,
    required this.name,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MarkdownViewerScreen(
                      filePath: path,
                      contents: name,
                    )));
      },
    );
  }
}
