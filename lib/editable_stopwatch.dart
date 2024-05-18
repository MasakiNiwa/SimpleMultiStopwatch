class EditableStopwatch {
  final Stopwatch _stopwatch = Stopwatch();
  Duration _offset = Duration.zero;

  bool get isRunning {
    return _stopwatch.isRunning;
  }

  Duration get elapsed {
    return _stopwatch.elapsed + _offset;
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
    _offset = Duration.zero;
    _stopwatch.reset();
  }

  void setOffsetTime(Duration offset) {
    _offset = offset;
  }

  void addOffsetTime(Duration offset) {
    _offset += offset;
  }

  String timeToString() {
    return "${days.toString().padLeft(2, '0')}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
