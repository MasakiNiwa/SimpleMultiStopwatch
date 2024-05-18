import 'package:shared_preferences/shared_preferences.dart';

class DataStorageFacade {
  Future<void> setStringList(String key, List<String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, data);
  }

  Future<List<String>> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<void> setDateTime(key, DateTime data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data.toIso8601String());
  }

  Future<DateTime> getDateTime(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temp = prefs.getString(key) ?? DateTime.now().toIso8601String();
    return DateTime.parse(temp);
  }

  Future<void> setBoolList(key, List<bool> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i]) {
        temp.add("1");
      } else {
        temp.add("0");
      }
    }
    prefs.setStringList(key, temp);
  }

  Future<List<bool>> getBoolList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<bool> temp = [];
    List<String> data = prefs.getStringList(key) ?? [];
    for (int i = 0; i < data.length; i++) {
      temp.add((int.parse(data[i]) == 0 ? false : true));
    }
    return temp;
  }

  Future<void> setIntList(String key, List<int> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    for (int i = 0; i < data.length; i++) {
      temp.add(data[i].toString());
    }
    prefs.setStringList(key, temp);
  }

  Future<List<int>> getIntList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<int> temp = [];
    List<String> data = prefs.getStringList(key) ?? [];
    for (int i = 0; i < data.length; i++) {
      temp.add(int.parse(data[i]));
    }
    return temp;
  }

  Future<void> setDurationList(String key, List<Duration> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    for (int i = 0; i < data.length; i++) {
      temp.add(data[i].inMilliseconds.toString());
    }
    prefs.setStringList(key, temp);
  }

  Future<List<Duration>> getDurationList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Duration> temp = [];
    List<String> data = prefs.getStringList(key) ?? [];
    for (int i = 0; i < data.length; i++) {
      temp.add(Duration(milliseconds: int.parse(data[i])));
    }
    return temp;
  }
}
