import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  ///
  /// Saves [value] with [key] in SharedPreferences.
  ///
  /// Supported data types for [value] are [int], [double], [String], [bool], and [List]<String>.
  ///
  /// Eg: await Shared.pref<int>(45,"key");
  static Future<bool> save<T>(T value, String key) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      bool? success;

      if (value is int) {
        success = await pref.setInt(key, value);
      } else if (value is double) {
        success = await pref.setDouble(key, value);
      } else if (value is String) {
        success = await pref.setString(key, value);
      } else if (value is bool) {
        success = await pref.setBool(key, value);
      } else if (value is List<String>) {
        success = await pref.setStringList(key, value);
      } else {
        throw ArgumentError('Unsupported data type: ${value.runtimeType}');
      }

      if (success) {
        debugPrint("$value saved with key: \"$key\"");
      }

      return success;
    } catch (e) {
      rethrow;
    }
  }

  ///
  /// Retrieves the [value] stored with [key] from SharedPreferences.
  ///
  /// Returns the value of type [T].
  ///
  /// Eg: final int res = await Shared.pref<int>("key");
  static Future<T?> get<T>(String key) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      T? result;

      if (T == int) {
        result = pref.getInt(key) as T?;
      } else if (T == double) {
        result = pref.getDouble(key) as T?;
      } else if (T == String) {
        result = pref.getString(key) as T?;
      } else if (T == bool) {
        result = pref.getBool(key) as T?;
      } else if (T == List<String>) {
        result = pref.getStringList(key) as T?;
      } else {
        throw ArgumentError('Unsupported data type: $T');
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  ///
  /// Removes the stored [value] associated with [key] from SharedPreferences.
  ///
  /// Eg: final success = await Shared.pref("key");
  static Future<bool> remove(String key) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      return await pref.remove(key);
    } catch (e) {
      rethrow;
    }
  }
}
