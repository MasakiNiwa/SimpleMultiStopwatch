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

  //タイマーのオフセット(秒)とメモのリスト
  //状態保存と復元に使用します
  //Lists to store the offset (in seconds) and memo for each timer.
  //Used for saving and restoring app state.
  List<String> timerOffsetList = [];
  List<String> timerMemoList = [];
  List<String> timerIsRunningList = [];
  String closeTime = DateTime.now().toIso8601String();

  //追加ボタンが押されたときに呼び出すメソッド
  //FocusTimerのインスタンスと対応するGlobalObjectKeyを作成してリストに追加します
  //作成されるFocusTimerには何もない初期値が渡されるようにします
  //タイマーを追加したら画面を更新します
  //Method called when the Add button is pressed.
  //Creates a new FocusTimer instance and adds it to the lists.
  //Sets the initial values for the timer to 0 seconds and an empty memo.
  //Updates the UI after adding the timer.
  void addTimer() {
    saveState();
    FocusTimer timer = FocusTimer(closeTime: DateTime.now());
    timers.add(timer);
    globalTimerKeys.add(GlobalObjectKey(timer));
    timerOffsetList.add("0");
    timerMemoList.add("");
    timerIsRunningList.add("0");
    setState(() {});
  }

  //保存済みのアプリの状態(保有しているタイマー)を復元するメソッド
  //Shared_Preferencesを使用します
  //まず最初に、保存をしていたタイマーのオフセット秒とメモのリストを読み込みます
  //読み込んだリストの個数だけFocusTimerインスタンスを作成してメインページ保有リストに追加します
  //※実際にオフセット秒とメモをタイマーに設定するタイミングは、ReorderableListView.builderでWidgetを画面にのせるタイミングになります
  //Method to restore the saved app state (list of timers).
  //Uses SharedPreferences to retrieve data.
  //Initially, retrieves the list of saved timer offset seconds and memos.
  //Creates FocusTimer instances for each item in the retrieved list and adds them to the main page's list.
  //Note: The actual offset seconds and memos are set to the timers when the widgets are displayed on the screen using ReorderableListView.builder.
  Future<void> restoreState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    timerOffsetList = prefs.getStringList('timer_offset_list') ?? [];
    timerMemoList = prefs.getStringList('timer_memo_list') ?? [];
    timerIsRunningList = prefs.getStringList('timer_isrunning_list') ?? [];
    closeTime =
        prefs.getString('timer_closetime') ?? DateTime.now().toIso8601String();

    if (timerOffsetList.length != timerMemoList.length) {
      timerOffsetList = [];
      timerMemoList = [];
      timerIsRunningList = [];
    } else if (timerOffsetList.length != timerIsRunningList.length) {
      timerOffsetList = [];
      timerMemoList = [];
      timerIsRunningList = [];
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
  //Shared_Preferencesを使用します
  //保存時点のタイマーのglobalTimerKeysのリストを使用して処理をおこないます
  //globalTimerKeysの個数だけfor文をまわして、それぞれのkeyからFocusTimerStateのプロパティにアクセスしてタイマーの状態を読み込みます
  //最後に、読み込んだタイマーの状態のリストを保存します
  //Method to save the app state (list of timers).
  //Uses SharedPreferences to store data.
  //Operates using the globalTimerKeys list of timers at the time of saving.
  //Iterates through the globalTimerKeys list, accessing the FocusTimerState properties for each key to retrieve timer state information.
  //Finally, saves the retrieved list of timer state information.
  Future<void> saveState() async {
    timerOffsetList = [];
    timerMemoList = [];
    timerIsRunningList = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (globalTimerKeys.isNotEmpty) {
      for (int i = 0; i < globalTimerKeys.length; i++) {
        int offset =
            globalTimerKeys[i].currentState?.stopwatch.elapsedSeconds ?? 0;
        timerOffsetList.add(offset.toString());
        String text =
            globalTimerKeys[i].currentState?.textController.text ?? '';
        timerMemoList.add(text);
        bool isrunnning =
            globalTimerKeys[i].currentState?.stopwatch.isRunning ?? false;
        bool ispaused = globalTimerKeys[i].currentState?.isPaused ?? false;
        if (isrunnning || ispaused) {
          timerIsRunningList.add("1");
        } else {
          timerIsRunningList.add("0");
        }
      }
    }
    await prefs.setStringList('timer_offset_list', timerOffsetList);
    await prefs.setStringList('timer_memo_list', timerMemoList);
    await prefs.setStringList('timer_isrunning_list', timerIsRunningList);
    closeTime = DateTime.now().toIso8601String();
    await prefs.setString('timer_closetime', closeTime);
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

  //disposeメソッドをオーバーライドします
  //アプリ終了時にデータを保存するようにします
  //※現時点ではdisposeがうまく呼び出されていないように感じています
  //Overrides the dispose method.
  //Disposes of the widget and saves the app state.
  //Note: Currently, it seems that the dispose method is not being called properly.
  @override
  void dispose() {
    saveState();
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
            style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.lightBlue[100],
        actions: [
          ElevatedButton(
            onPressed: () {
              timers.clear();
              globalTimerKeys.clear();
              timerOffsetList.clear();
              timerMemoList.clear();
              timerIsRunningList.clear();
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
                isRunning:
                    (int.parse(timerIsRunningList[index]) == 0 ? false : true),
                closeTime: DateTime.parse(closeTime),
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
