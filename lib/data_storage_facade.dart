import 'package:shared_preferences/shared_preferences.dart';

//SharedPreferencesのラッパークラスです
//データ型変換をメインコードから分離します
//This class acts as a wrapper for SharedPreferences, separating data type
//conversions from your main application code. It provides methods for
//storing and retrieving various data types in a type-safe manner.
class DataStorageFacade {
  //SharedPreferencesのインスタンスを初回利用時に格納します
  //Static instance of SharedPreferences
  //This ensures a single instance is used throughout the app
  static SharedPreferences? _prefs;

  //StringList型の保存
  //Saves a list of strings
  Future<void> setStringList(String key, List<String> data) async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setStringList(key, data);
  }

  //StringList型の取得
  //Retrieves a list of strings
  Future<List<String>> getStringList(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getStringList(key) ?? [];
  }

  //DateTime型の保存
  //Saves a DateTime object
  Future<void> setDateTime(key, DateTime data) async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setString(key, data.toIso8601String());
  }

  //DateTime型の取得
  //Retrieves a DateTime object
  Future<DateTime> getDateTime(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    String temp = _prefs!.getString(key) ?? DateTime.now().toIso8601String();
    return DateTime.parse(temp);
  }

  //boolList型の保存
  //Saves a list of booleans
  Future<void> setBoolList(key, List<bool> data) async {
    _prefs ??= await SharedPreferences.getInstance();
    List<String> temp = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i]) {
        temp.add("1");
      } else {
        temp.add("0");
      }
    }
    _prefs!.setStringList(key, temp);
  }

  //boolList型の取得
  //Retrieves a list of booleans
  Future<List<bool>> getBoolList(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    List<bool> temp = [];
    List<String> data = _prefs!.getStringList(key) ?? [];
    for (int i = 0; i < data.length; i++) {
      temp.add((int.parse(data[i]) == 0 ? false : true));
    }
    return temp;
  }

  //intList型の保存
  //Saves a list of integers
  Future<void> setIntList(String key, List<int> data) async {
    _prefs ??= await SharedPreferences.getInstance();
    List<String> temp = [];
    for (int i = 0; i < data.length; i++) {
      temp.add(data[i].toString());
    }
    _prefs!.setStringList(key, temp);
  }

  //intList型の取得
  //Retrieves a list of integers
  Future<List<int>> getIntList(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    List<int> temp = [];
    List<String> data = _prefs!.getStringList(key) ?? [];
    for (int i = 0; i < data.length; i++) {
      temp.add(int.parse(data[i]));
    }
    return temp;
  }

  //DurationList型の保存
  //Saves a list of Durations
  Future<void> setDurationList(String key, List<Duration> data) async {
    _prefs ??= await SharedPreferences.getInstance();
    List<String> temp = [];
    for (int i = 0; i < data.length; i++) {
      temp.add(data[i].inMilliseconds.toString());
    }
    _prefs!.setStringList(key, temp);
  }

  //DurationList型の取得
  //Retrieves a list of Durations
  Future<List<Duration>> getDurationList(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    List<Duration> temp = [];
    List<String> data = _prefs!.getStringList(key) ?? [];
    for (int i = 0; i < data.length; i++) {
      temp.add(Duration(milliseconds: int.parse(data[i])));
    }
    return temp;
  }
}
