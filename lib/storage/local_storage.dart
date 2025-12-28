import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late final SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  static String getString(String key) {
    return prefs.getString(key) ?? '';
  }

  static Future<void> setInt(String key, String value) async {
    await prefs.setString(key, value);
  }

  static int getInt(String key) {
    return prefs.getInt(key) ?? -1;
  }

  static Future<void> setDouble(String key, double value) async {
    await prefs.setDouble(key, value);
  }

  static double getDouble(String key) {
    return prefs.getDouble(key) ?? -1;
  }

  static Future<void> setStringList(String key, List<String> value) async {
    await prefs.setStringList(key, value);
  }

  static List<String> getStringList(String key) {
    return prefs.getStringList(key) ?? [];
  }
}
