class EditableStopwatch {
  final Stopwatch _stopwatch = Stopwatch();
  int offsetSeconds = 0;
  EditableStopwatch({this.offsetSeconds = 0});

  bool get isRunning {
    return _stopwatch.isRunning;
  }

  Duration get elapsed {
    return _stopwatch.elapsed + Duration(seconds: offsetSeconds);
  }

  int get elapsedSeconds {
    return elapsed.inSeconds;
  }

  int get days {
    return elapsed.inDays;
  }

  int get hours {
    return elapsed.inHours % 24;
  }

  int get minutes {
    return elapsed.inMinutes % 60;
  }

  int get seconds {
    return elapsed.inSeconds % 60;
  }

  void start() {
    _stopwatch.start();
  }

  void stop() {
    _stopwatch.stop();
  }

  void reset() {
    offsetSeconds = 0;
    _stopwatch.reset();
  }

  void setOffsetTime({int seconds = 0}) {
    offsetSeconds = seconds;
  }

  void addOffsetTime(
      {int days = 0, int hours = 0, int minutes = 0, int seconds = 0}) {
    offsetSeconds += Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    ).inSeconds;
  }

  String timeToString() {
    return "${days.toString().padLeft(2, '0')}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
