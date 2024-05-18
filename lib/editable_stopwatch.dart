//offsetで表示時間を調整できるStopwatchのラッパークラスです
//Stopwatchクラスのインスタンスをメンバーとして持っています
//EditableStopwatch class that wraps a Stopwatch and allows adjusting the displayed time with an offset.
//Holds a Stopwatch instance as a member.
class EditableStopwatch {
  //プライベート変数にstopwatchとoffset時間を格納
  //Private variables to store the stopwatch and offset time.
  final Stopwatch _stopwatch = Stopwatch();
  Duration _offset = Duration.zero;

  //sotpwatchが動作しているか
  //Whether the stopwatch is running.
  bool get isRunning {
    return _stopwatch.isRunning;
  }

  //offsetを反映した経過時間
  //Elapsed time with offset applied.
  Duration get elapsed {
    return _stopwatch.elapsed + _offset;
  }

  //表示時間の『日』
  //Days in the displayed time.
  int get days {
    return elapsed.inDays;
  }

  //表示時間の『時』
  //Hours in the displayed time.
  int get hours {
    return elapsed.inHours % 24;
  }

  //表示時間の『分』
  //Minutes in the displayed time.
  int get minutes {
    return elapsed.inMinutes % 60;
  }

  //表示時間の『秒』
  //Seconds in the displayed time.
  int get seconds {
    return elapsed.inSeconds % 60;
  }

  //stopwatchを開始
  //Starts the stopwatch.
  void start() {
    _stopwatch.start();
  }

  //stopwatchを停止
  //Stops the stopwatch.
  void stop() {
    _stopwatch.stop();
  }

  //stopwatchをリセット
  //Resets the stopwatch.
  void reset() {
    _offset = Duration.zero;
    _stopwatch.reset();
  }

  //offsetを設定
  //Sets the offset time.
  void setOffsetTime(Duration offset) {
    _offset = offset;
  }

  //offsetを加算
  //Adds to the offset.
  void addOffsetTime(Duration offset) {
    _offset += offset;
  }

  //表示時間を文字列で返すメソッド
  //Returns the displayed time as a string.
  String timeToString() {
    return "${days.toString().padLeft(2, '0')}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
