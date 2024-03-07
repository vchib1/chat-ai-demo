import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<bool> saveData<T>(T value, String key) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      if (value is int) {
        return await pref.setInt(key, value);
      } else if (value is double) {
        return await pref.setDouble(key, value);
      } else if (value is String) {
        return await pref.setString(key, value);
      } else if (value is bool) {
        return await pref.setBool(key, value);
      } else if (value is List<String>) {
        return await pref.setStringList(key, value);
      } else {
        throw ArgumentError(
            "Please ensure the data type is of only [int, double, String, bool, List<String>] , example: await SharedPref.saveData<int>( 1 , \"keyName\" );");
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<T?> getData<T>(String key) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      dynamic result;

      if (T == int) {
        result = pref.getInt(key);
      } else if (T == double) {
        result = pref.getDouble(key);
      } else if (T == String) {
        result = pref.getString(key);
      } else if (T == bool) {
        result = pref.getBool(key);
      } else if (T == List<String>) {
        result = pref.getStringList(key);
      } else {
        throw ArgumentError(
            "Please ensure the data type is of only [int, double, String, bool, List<String>] , example: await SharedPref.getData<int>( \"keyName\" );");
      }

      return result as T?;
    } catch (e) {
      rethrow;
    }
  }
}
