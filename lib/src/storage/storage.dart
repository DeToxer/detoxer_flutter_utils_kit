// ignore_for_file: unused_element

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utils_kit/utils_kit.dart';

final class StorageFactory {
  static BasePreferenceStore createStorage(String domain) {
    if (isTesting) {
      return _MemoryPreferenceStore();
    }
    return _PreferenceStore(domain: domain);
  }

  static BasePreferenceStore createSecureStorage(
    String domain, {
    AndroidOptions? androidOptions,
    IOSOptions? iosOptions,
  }) {
    if (isTesting) {
      return _MemoryPreferenceStore();
    }
    return _SecurePreferenceStore(
      domain: domain,
      androidOptions: androidOptions,
      iosOptions: iosOptions,
    );
  }
}

abstract class BasePreferenceStore {
  Future<String?> getString(String key);

  Future<bool> setString(String key, String value);

  Future<int?> getInt(String key);

  Future<bool> setInt(String key, int value);

  Future<bool> getBool(String key);

  Future<bool> setBool(String key, bool value);

  Future<bool?> getBoolNullable(String key);

  Future<double?> getDouble(String key);

  Future<bool> setDouble(String key, double value);

  Future<bool> remove(String key);

  Future<bool> clear();
}

final class _PreferenceStore extends BasePreferenceStore {
  final String domain;

  Future<SharedPreferences> get _storage => SharedPreferences.getInstance();

  _PreferenceStore({required this.domain});

  @override
  Future<String?> getString(String key) async {
    final prefs = await _storage;
    return prefs.getString(_getKey(key));
  }

  @override
  Future<bool> setString(String key, String value) async {
    final prefs = await _storage;
    return prefs.setString(_getKey(key), value);
  }

  @override
  Future<int?> getInt(String key) async {
    final prefs = await _storage;
    return prefs.getInt(_getKey(key));
  }

  @override
  Future<bool> setInt(String key, int value) async {
    final prefs = await _storage;
    return prefs.setInt(_getKey(key), value);
  }

  @override
  Future<bool> getBool(String key) async {
    final prefs = await _storage;
    return prefs.getBool(_getKey(key)) ?? false;
  }

  @override
  Future<bool?> getBoolNullable(String key) async {
    final prefs = await _storage;
    return prefs.getBool(_getKey(key));
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    final prefs = await _storage;
    return prefs.setBool(_getKey(key), value);
  }

  @override
  Future<double?> getDouble(String key) async {
    final prefs = await _storage;
    return prefs.getDouble(key);
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    final prefs = await _storage;
    return prefs.setDouble(key, value);
  }

  @override
  Future<bool> clear() async {
    final prefs = await _storage;
    for (final key in prefs.getKeys()) {
      if (key.startsWith("$domain.")) {
        await prefs.remove(key);
      }
    }
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    final prefs = await _storage;
    return prefs.remove(_getKey(key));
  }

  String _getKey(String key) {
    return '$domain.$key';
  }

  static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final List<bool> successStates = [];
    for (final key in prefs.getKeys()) {
      final bool success = await prefs.remove(key);
      successStates.add(success);
    }
    return !successStates.contains(false);
  }
}

final class _SecurePreferenceStore extends BasePreferenceStore {
  final String domain;

  final FlutterSecureStorage _storage;

  _SecurePreferenceStore({required this.domain, AndroidOptions? androidOptions, IOSOptions? iosOptions})
      : _storage = FlutterSecureStorage(
          iOptions: iosOptions ?? IOSOptions(accessibility: KeychainAccessibility.first_unlock),
          aOptions: androidOptions ??
              AndroidOptions(
                encryptedSharedPreferences: true,
              ),
        );

  @override
  Future<String?> getString(String key) async {
    return _storage.read(key: _getKey(key));
  }

  @override
  Future<bool> setString(String key, String value) async {
    await _storage.write(key: _getKey(key), value: value);
    return true;
  }

  @override
  Future<int?> getInt(String key) async {
    final String? value = await _storage.read(key: _getKey(key));
    if (value != null) {
      return int.tryParse(value);
    }
    return null;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    await _storage.write(key: _getKey(key), value: value.toString());
    return true;
  }

  @override
  Future<bool> getBool(String key) async {
    final String? value = await _storage.read(key: _getKey(key));
    return value == "1";
  }

  @override
  Future<bool?> getBoolNullable(String key) async {
    final String? value = await _storage.read(key: _getKey(key));
    return value != null ? value == "1" : null;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    await _storage.write(key: _getKey(key), value: value ? "1" : "0");
    return true;
  }

  @override
  Future<double?> getDouble(String key) async {
    final String? value = await _storage.read(key: _getKey(key));
    if (value != null) {
      return double.tryParse(value);
    }
    return null;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    await _storage.write(key: _getKey(key), value: value.toString());
    return true;
  }

  @override
  Future<bool> clear() async {
    final Map<String, String> all = await _storage.readAll();
    final Set<String> keys = {};
    all.forEach((key, value) {
      if (key.startsWith("$domain.")) {
        keys.add(key);
      }
    });

    for (final key in keys) {
      await remove(key);
    }
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    await _storage.delete(key: _getKey(key));
    return true;
  }

  String _getKey(String key) => '$domain.$key';

  static Future<bool> clearAll() async {
    const storage = FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device),
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    await storage.deleteAll();
    return true;
  }
}

final class _MemoryPreferenceStore extends BasePreferenceStore {
  final Map<String, String> _strings = <String, String>{};
  final Map<String, int> _ints = <String, int>{};
  final Map<String, bool> _booleans = <String, bool>{};
  final Map<String, double> _doubles = <String, double>{};

  @override
  Future<String?> getString(String key) async {
    return _strings[key];
  }

  @override
  Future<bool> setString(String key, String value) async {
    _strings[key] = value;
    return true;
  }

  @override
  Future<int?> getInt(String key) async {
    return _ints[key];
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _ints[key] = value;
    return true;
  }

  @override
  Future<bool> getBool(String key) async {
    return _booleans[key] ?? false;
  }

  @override
  Future<bool?> getBoolNullable(String key) async {
    return _booleans[key];
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _booleans[key] = value;
    return true;
  }

  @override
  Future<double?> getDouble(String key) async {
    return _doubles[key];
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _doubles[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    final removedString = _strings.remove(key) != null;
    final removedInt = _ints.remove(key) != null;
    final removedBool = _booleans.remove(key) != null;
    final removedDouble = _doubles.remove(key) != null;
    return removedString || removedInt || removedBool || removedDouble;
  }

  @override
  Future<bool> clear() async {
    _strings.clear();
    _ints.clear();
    return true;
  }
}
