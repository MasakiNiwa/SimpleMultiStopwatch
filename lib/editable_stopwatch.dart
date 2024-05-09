//表示時間の変更などが出来るように、Stopwatchクラスを拡張したクラス
//クラス内にオフセット時間(秒)を持たせて時間を調整して出力するようにしています
//まだ元のStopwatchクラスと完全に整合性がとれるようにはできていません
// An extension of the Stopwatch class that allows you to change the display time, etc.
// The class has an offset time (in seconds) that is used to adjust the time before outputting it.
// It is not yet fully compatible with the original Stopwatch class.
class EditableStopwatch extends Stopwatch {
  //オフセット時間(秒)
  // Offset time in seconds
  int offsetSeconds = 0;

  //コンストラクタ(オフセット時間(秒)を初期値として渡せます)
  // Constructor (you can pass the offset time (in seconds) as the initial value)
  EditableStopwatch({this.offsetSeconds = 0});

  //EditableStopwatchの現在時間(Duration型)
  // Current time (Duration type) of the EditableStopwatch
  @override
  Duration get elapsed {
    return super.elapsed + Duration(seconds: offsetSeconds);
  }

  //EditableStopwatchの現在時間(ミリ秒単位)
  // Current time (in milliseconds) of the EditableStopwatch
  @override
  int get elapsedMilliseconds {
    return elapsed.inMilliseconds;
  }

  //EditableStopwatchの現在時間(秒単位)
  // Current time (in seconds) of the EditableStopwatch
  int get elapsedSeconds {
    return elapsed.inSeconds;
  }

  //EditableStopwatchの表示時間の『日』
  // Days in the display time of the EditableStopwatch
  int get days {
    return elapsed.inDays;
  }

  //EditableStopwatchの表示時間の『時』
  // Hours in the display time of the EditableStopwatch
  int get hours {
    return elapsed.inHours % 24;
  }

  //EditableStopwatchの表示時間の『分』
  // Minutes in the display time of the EditableStopwatch
  int get minutes {
    return elapsed.inMinutes % 60;
  }

  //EditableStopwatchの表示時間の『秒』
  // Seconds in the display time of the EditableStopwatch
  int get seconds {
    return elapsed.inSeconds % 60;
  }

  //オフセット時間を設定します
  // Sets the offset time
  void setOffsetTime({int seconds = 0}) {
    offsetSeconds = seconds;
  }

  //オフセット時間を調整します
  // Adjusts the offset time
  void addOffsetTime(
      {int days = 0, int hours = 0, int minutes = 0, int seconds = 0}) {
    offsetSeconds += Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    ).inSeconds;
  }

  //EditableStopwatchの現在時間をリセットします
  // Resets the current time of the EditableStopwatch
  @override
  reset() {
    setOffsetTime(seconds: 0);
    super.reset();
  }

  //EditableStopwatchの表示時間(dd:hh:mm:ss)
  // Display time (dd:hh:mm:ss) of the EditableStopwatch
  String timeToString() {
    return "${days.toString().padLeft(2, '0')}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
