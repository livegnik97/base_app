// ignore_for_file: type_literal_in_constant_pattern

import 'dart:convert';

import 'package:base_app/core/helpers/custom_log_print.dart';
import 'package:base_app/data/shared_preferences/object_to_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'my_shared_constants.dart';

/*
MODO DE USAR:
  - getInt or getIntOrNull: devuelve el valor int de la key, si no existe devuelve el defaultValue
  - getDouble or getDoubleOrNull: devuelve el valor double de la key, si no existe devuelve el defaultValue
  - getBool or getBoolOrNull: devuelve el valor bool de la key, si no existe devuelve el defaultValue
  - getString or getStringOrNull: devuelve el valor String de la key, si no existe devuelve el defaultValue
  - getStringList or getStringListOrNull: devuelve el valor List<String> de la key, si no existe devuelve el defaultValue
  - removeKey: elimina la key
  - setValue: setea el valor de la key, tipos admitidos: int, bool, double, String, List<String> o una clase con el mixin ObjectToShared

  - getObjectOrNull: devuelve un objeto de una clase, si no existe devuelve null. Se debe pasar una funcion que reciba un Map<String, dynamic> y devuelva el objeto
    - Ejemplo:
      class ExampleClass with ObjectToShared {
        String? name;
        ExampleClass({this.name});

        @override
        Map<String, dynamic> toMap() {
          return {'name': name};
        }

        factory ExampleClass.fromMap(Map<String, dynamic> map) {
          return ExampleClass(name: map['name']);
        }
      }

      void main() async {
        ExampleClass object1 = ExampleClass();
        MyShared.setValue('privateKey', object1);
        ExampleClass? object2 = await MyShared.getObjectOrNull(
          'privateKey',
          ExampleClass.fromMap,
        );
        print(object2?.name ?? 'Object is null');
      }
*/

class MyShared {
  static Future<SharedPreferences> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs;
  }

  static Future<int> getInt(String key, int defaultValue) async {
    return await getIntOrNull(key) ?? defaultValue;
  }

  static Future<int?> getIntOrNull(String key) async {
    try {
      final prefs = await _getSharedPrefs();
      return prefs.getInt(key);
    } catch (e) {
      CustomPrint.call("SharedPreferences getIntOrNull error: $e");
    }
    return null;
  }

  static Future<double> getDouble(String key, double defaultValue) async {
    return await getDoubleOrNull(key) ?? defaultValue;
  }

  static Future<double?> getDoubleOrNull(String key) async {
    try {
      final prefs = await _getSharedPrefs();
      return prefs.getDouble(key);
    } catch (e) {
      CustomPrint.call("SharedPreferences getDoubleOrNull error: $e");
    }
    return null;
  }

  static Future<bool> getBool(String key, bool defaultValue) async {
    return await getBoolOrNull(key) ?? defaultValue;
  }

  static Future<bool?> getBoolOrNull(String key) async {
    try {
      final prefs = await _getSharedPrefs();
      return prefs.getBool(key);
    } catch (e) {
      CustomPrint.call("SharedPreferences getBoolOrNull error: $e");
    }
    return null;
  }

  static Future<String> getString(String key, String defaultValue) async {
    return await getStringOrNull(key) ?? defaultValue;
  }

  static Future<String?> getStringOrNull(String key) async {
    try {
      final prefs = await _getSharedPrefs();
      return prefs.getString(key);
    } catch (e) {
      CustomPrint.call("SharedPreferences getStringOrNull error: $e");
    }
    return null;
  }

  static Future<List<String>> getStringList(
    String key,
    List<String> defaultValue,
  ) async {
    return await getStringListOrNull(key) ?? defaultValue;
  }

  static Future<List<String>?> getStringListOrNull(String key) async {
    try {
      final prefs = await _getSharedPrefs();
      return prefs.getStringList(key);
    } catch (e) {
      CustomPrint.call("SharedPreferences getStringListOrNull error: $e");
    }
    return null;
  }

  static Future<T?> getObjectOrNull<T>(
    String key,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    try {
      final prefs = await _getSharedPrefs();
      final map = prefs.getString(key);
      if (map == null) return null;
      final json = jsonDecode(map);
      return fromMap(json);
    } catch (e) {
      CustomPrint.call("SharedPreferences getStringListOrNull error: $e");
    }
    return null;
  }

  static Future<bool> removeKey(String key) async {
    final prefs = await _getSharedPrefs();
    return await prefs.remove(key);
  }

  static Future<bool> setValue<T>(String key, T? value) async {
    final prefs = await _getSharedPrefs();
    if (value == null) {
      return await removeKey(key);
    }
    switch (T) {
      case int:
        return await prefs.setInt(key, value as int);
      case bool:
        return await prefs.setBool(key, value as bool);
      case double:
        return await prefs.setDouble(key, value as double);
      case String:
        return await prefs.setString(key, value as String);
      case const (List<String>):
        return await prefs.setStringList(key, value as List<String>);
      case ObjectToShared:
        return await prefs.setString(
          key,
          jsonEncode((value as ObjectToShared).toMap()),
        );
      default:
        throw UnimplementedError(
          'Set not implemented for type ${T.runtimeType}',
        );
    }
  }
}
