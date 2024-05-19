import 'package:flutter/material.dart';
import 'package:simple_multi_stopwatch/focus_timer.dart';
import 'package:simple_multi_stopwatch/data_storage_facade.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

//アプリのメインページのStatefulWidgetクラスです
//This class represents the main homepage of the app.
//It extends the StatefulWidget class and maintains a list of FocusTimer objects.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//アプリのメインページWidgetのStateクラスです
//This class represents the state of the MyHomePage widget.
//It manages the list of FocusTimer objects and handles user interactions.
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //メインページが保有するタイマーのリスト
  //List to store the FocusTimer objects maintained by the main page.
  final List<FocusTimer> timers = [];
  //メインページが保有するタイマーのGlobalObjectKeyのリスト
  //タイマーを特定するために使用します
  //List of GlobalObjectKey objects for each FocusTimer, used to identify timers.
  final List<GlobalObjectKey<FocusTimerState>> globalTimerKeys = [];
  //データ保存用にShared_Preferencesのラッパークラスをインスタンス化します
  //An instance of the DataStorageFacade class, which is a wrapper around Shared Preferences for data storage.
  final DataStorageFacade dataStorageFacade = DataStorageFacade();

  //タイマーの状態のリスト
  //アプリの状態保存と復元に使用します
  //List of timer states.
  //Used to save and restore the app state.
  List<Duration> timerOffsetList = [];
  List<String> timerMemoList = [];
  List<bool> timerIsRunningList = [];
  List<int> timerColorList = [];
  DateTime closeTime = DateTime.now();

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
    timerColorList.add(4);
    setState(() {});
  }

  //保存済みのアプリの状態(保有しているタイマー)を復元するメソッド
  //Shared_PreferencesのラッパークラスであるData_Storage_Facadeを使用します
  //まず最初に、保存をしていたタイマーのオフセット秒とメモのリストを読み込みます
  //読み込んだリストの個数だけFocusTimerインスタンスを作成してメインページ保有リストに追加します
  //※実際にオフセット秒とメモをタイマーに設定するタイミングは、ReorderableListView.builderでWidgetを画面にのせるタイミングになります
  //Method to restore the saved app state (list of timers).
  //Uses the Data_Storage_Facade, a wrapper class for Shared_Preferences.
  //Initially, retrieves the list of saved timer offset seconds and memos.
  //Creates FocusTimer instances for each item in the retrieved list and adds them to the main page's list.
  //Note: The actual offset seconds and memos are set to the timers when the widgets are displayed on the screen using ReorderableListView.builder.
  Future<void> restoreState() async {
    timerOffsetList =
        await dataStorageFacade.getDurationList('timer_offset_list');
    timerMemoList = await dataStorageFacade.getStringList('timer_memo_list');
    timerIsRunningList =
        await dataStorageFacade.getBoolList('timer_isrunning_list');
    timerColorList = await dataStorageFacade.getIntList('timer_color_list');
    closeTime = await dataStorageFacade.getDateTime('timer_closetime');

    if (timerOffsetList.length != timerMemoList.length) {
      timerOffsetList = [];
      timerMemoList = [];
      timerIsRunningList = [];
      timerColorList = [];
    } else if (timerOffsetList.length != timerIsRunningList.length) {
      timerOffsetList = [];
      timerMemoList = [];
      timerIsRunningList = [];
      timerColorList = [];
    } else if (timerOffsetList.length != timerColorList.length) {
      timerOffsetList = [];
      timerMemoList = [];
      timerIsRunningList = [];
      timerColorList = [];
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
    if (globalTimerKeys.isNotEmpty) {
      for (int i = 0; i < globalTimerKeys.length; i++) {
        Duration offset =
            globalTimerKeys[i].currentState?.stopwatch.elapsed ?? Duration.zero;
        timerOffsetList.add(offset);
        String text =
            globalTimerKeys[i].currentState?.textController.text ?? '';
        timerMemoList.add(text);
        int colorIndex =
            globalTimerKeys[i].currentState?.backgroundColorIndex ?? 4;
        timerColorList.add(colorIndex);
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
        'timer_offset_list', timerOffsetList);
    await dataStorageFacade.setStringList('timer_memo_list', timerMemoList);
    await dataStorageFacade.setBoolList(
        'timer_isrunning_list', timerIsRunningList);
    await dataStorageFacade.setIntList('timer_color_list', timerColorList);
    await dataStorageFacade.setDateTime('timer_closetime', DateTime.now());
  }

  //initStateメソッドをオーバーライドします
  //アプリ起動時にデータが復元されるようにします
  //Overrides the initState method.
  //Initializes the state of the widget.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    restoreState();
  }

  @override
  void dispose() {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
            ('Simple Multi Stopwatch :  ${timers.length.toString()} timers'),
            style: const TextStyle(
                fontSize: 18, color: Color.fromRGBO(220, 220, 220, 1))),
        backgroundColor: Colors.black,
        actions: [
          ElevatedButton(
            onPressed: () {
              timers.clear();
              globalTimerKeys.clear();
              timerOffsetList.clear();
              timerMemoList.clear();
              timerIsRunningList.clear();
              timerColorList.clear();
              setState(() {});
            },
            child: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: ReorderableListView.builder(
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
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      globalTimerKeys[index]
                          .currentState
                          ?.backgroundColorIndex = 1;
                      globalTimerKeys[index].currentState?.backgroundColor =
                          timerColor[1] ?? Colors.white;
                    });
                  },
                  backgroundColor: timerColor[1] ?? Colors.white,
                  foregroundColor: timerColor[1] ?? Colors.white,
                  icon: Icons.palette,
                ),
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      globalTimerKeys[index]
                          .currentState
                          ?.backgroundColorIndex = 2;
                      globalTimerKeys[index].currentState?.backgroundColor =
                          timerColor[2] ?? Colors.white;
                    });
                  },
                  backgroundColor: timerColor[2] ?? Colors.white,
                  foregroundColor: timerColor[2] ?? Colors.white,
                  icon: Icons.palette,
                ),
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      globalTimerKeys[index]
                          .currentState
                          ?.backgroundColorIndex = 3;
                      globalTimerKeys[index].currentState?.backgroundColor =
                          timerColor[3] ?? Colors.white;
                    });
                  },
                  backgroundColor: timerColor[3] ?? Colors.white,
                  foregroundColor: timerColor[3] ?? Colors.white,
                  icon: Icons.palette,
                ),
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      globalTimerKeys[index]
                          .currentState
                          ?.backgroundColorIndex = 4;
                      globalTimerKeys[index].currentState?.backgroundColor =
                          timerColor[4] ?? Colors.white;
                    });
                  },
                  backgroundColor: timerColor[4] ?? Colors.white,
                  foregroundColor: timerColor[4] ?? Colors.white,
                  icon: Icons.palette,
                ),
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      globalTimerKeys[index]
                          .currentState
                          ?.backgroundColorIndex = 5;
                      globalTimerKeys[index].currentState?.backgroundColor =
                          timerColor[5] ?? Colors.white;
                    });
                  },
                  backgroundColor: timerColor[5] ?? Colors.white,
                  foregroundColor: timerColor[5] ?? Colors.white,
                  icon: Icons.palette,
                ),
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      globalTimerKeys[index]
                          .currentState
                          ?.backgroundColorIndex = 6;
                      globalTimerKeys[index].currentState?.backgroundColor =
                          timerColor[6] ?? Colors.white;
                    });
                  },
                  backgroundColor: timerColor[6] ?? Colors.white,
                  foregroundColor: timerColor[6] ?? Colors.white,
                  icon: Icons.palette,
                ),
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      globalTimerKeys[index]
                          .currentState
                          ?.backgroundColorIndex = 7;
                      globalTimerKeys[index].currentState?.backgroundColor =
                          timerColor[7] ?? Colors.white;
                    });
                  },
                  backgroundColor: timerColor[7] ?? Colors.white,
                  foregroundColor: timerColor[7] ?? Colors.white,
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
