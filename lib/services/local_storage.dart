import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{

  static void saveData(String key, dynamic value) async {
    final localStorage = await SharedPreferences.getInstance();
    if (value is int) {
      localStorage.setInt(key, value);
    } else if (value is double) {
      localStorage.setDouble(key, value);
    } else if (value is String) {
      localStorage.setString(key, value);
    } else if (value is List<String>) {
      localStorage.setStringList(key, value);
    } else if (value is bool) {
      localStorage.setBool(key, value);
    } else if (value is DateTime) {
      localStorage.setString(key, value.toIso8601String());
    }
  }

  static Future<dynamic> readData(String key) async {
    final localStorage = await SharedPreferences.getInstance();
    dynamic obj = localStorage.get(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    final localStorage = await SharedPreferences.getInstance();
    bool keyRemoved = await localStorage.remove(key);
    return keyRemoved;
  }

  static Future<bool> containsKeyInLocalData(String key) async {
    final localStorage = await SharedPreferences.getInstance();
    bool containsKey = localStorage.containsKey(key);
    return containsKey;
  }
}
