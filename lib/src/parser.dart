import 'package:utils_kit/utils_kit.dart';

final class Parser {
  static const int = _IntParser();
  static const double = _DoubleParser();
  static const string = _StringParser();
  static const list = _ListParser();
  static const map = _MapParser();
  static const dateTime = _DateTimeParser();
  static const bool = _BoolParser();
  static const url = _UrlParser();
}

class _IntParser {
  const _IntParser();

  int get(Map<String, dynamic>? obj, String key, {int defaultValue = 0}) => getNullable(obj, key) ?? defaultValue;

  int? getNullable(Map<String, dynamic>? obj, String key) {
    if (obj == null) return null;
    if (!obj.containsKey(key)) return null;
    final res = obj[key];
    if (res is int) return res;
    if (res is num) return res.toInt();
    if (res is String) {
      final parsedInt = int.tryParse(res);
      final parsedDouble = double.tryParse(res);
      return parsedInt ?? parsedDouble?.toInt();
    }
    return null;
  }

  int getWithKeys(Map<String, dynamic>? obj, List<String> keys, {int defaultValue = 0}) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null) ?? defaultValue;

  int? getWithKeysNullable(Map<String, dynamic>? obj, List<String> keys) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null);
}

class _DoubleParser {
  const _DoubleParser();

  double get(Map<String, dynamic>? obj, String key, {double defaultValue = 0.0}) => getNullable(obj, key) ?? defaultValue;

  double? getNullable(Map<String, dynamic>? obj, String key) {
    if (obj == null || !obj.containsKey(key)) return null;
    final res = obj[key];
    if (res is double) return res;
    if (res is num) return res.toDouble();
    if (res is String) return double.tryParse(res);
    return null;
  }

  double getWithKeys(Map<String, dynamic>? obj, List<String> keys, {double defaultValue = 0.0}) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null) ?? defaultValue;

  double? getWithKeysNullable(Map<String, dynamic>? obj, List<String> keys) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null);
}

class _StringParser {
  const _StringParser();

  String get(Map<String, dynamic>? obj, String key, {String defaultValue = ""}) => getNullable(obj, key) ?? defaultValue;

  String? getNullable(Map<String, dynamic>? obj, String key) {
    if (obj == null || !obj.containsKey(key)) return null;
    final res = obj[key];
    if (res is String) return res;
    if (res is num) return res.toString();
    return null;
  }

  String getWithKeys(Map<String, dynamic>? obj, List<String> keys, {String defaultValue = ""}) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null) ?? defaultValue;

  String? getWithKeysNullable(Map<String, dynamic>? obj, List<String> keys) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null);
}

class _ListParser {
  const _ListParser();

  List get(Map<String, dynamic>? obj, String key, {List defaultValue = const []}) => getNullable(obj, key) ?? List.from(defaultValue);

  List? getNullable(Map<String, dynamic>? obj, String key) {
    if (obj == null || !obj.containsKey(key)) return null;
    final res = obj[key];
    if (res is List) return res;
    return null;
  }

  List getWithKeys(Map<String, dynamic>? obj, List<String> keys, {List defaultValue = const []}) =>
      keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null) ?? List.from(defaultValue);

  List? getWithKeysNullable(Map<String, dynamic>? obj, List<String> keys) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null);
}

class _MapParser {
  const _MapParser();

  Map<String, dynamic> get(Map<String, dynamic>? obj, String key, {Map<String, dynamic> defaultValue = const {}}) => getNullable(obj, key) ?? Map.from(defaultValue);

  Map<String, dynamic>? getNullable(Map<String, dynamic>? obj, String key) {
    if (obj == null || !obj.containsKey(key)) return null;
    final res = obj[key];
    if (res is Map<String, dynamic>) return res;
    return null;
  }

  Map<String, dynamic> getWithKeys(Map<String, dynamic>? obj, List<String> keys, {Map<String, dynamic> defaultValue = const {}}) =>
      keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null) ?? Map.from(defaultValue);

  Map<String, dynamic>? getWithKeysNullable(Map<String, dynamic>? obj, List<String> keys) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null);
}

class _DateTimeParser {
  const _DateTimeParser();

  DateTime? getNullable(Map<String, dynamic>? obj, String key) {
    if (obj == null || !obj.containsKey(key)) return null;
    final res = obj[key];
    if (res is num) return DateTime.fromMillisecondsSinceEpoch(res.toInt() * 1000);
    if (res is String) return DateTime.tryParse(res);
    return null;
  }

  DateTime? getWithKeysNullable(Map<String, dynamic>? obj, List<String> keys) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null);
}

class _BoolParser {
  const _BoolParser();

  bool get(Map<String, dynamic>? obj, String key, {bool defaultValue = false}) => getNullable(obj, key) ?? defaultValue;

  bool? getNullable(Map<String, dynamic>? obj, String key) {
    if (obj == null || !obj.containsKey(key)) return null;
    final res = obj[key];
    if (res is bool) return res;
    if (res is String) {
      if (res.toLowerCase() == "true") return true;
      if (res.toLowerCase() == "false") return false;
    }
    return null;
  }

  bool getWithKeys(Map<String, dynamic>? obj, List<String> keys, {bool defaultValue = false}) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null) ?? defaultValue;

  bool? getWithKeysNullable(Map<String, dynamic>? obj, List<String> keys) => keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null);
}

class _UrlParser {
  const _UrlParser();

  Uri? getNullable(Map<String, dynamic>? obj, String key) {
    final url = Parser.string.getNullable(obj, key);
    if (url == null || url.isEmpty) return null;
    final parsedUri = Uri.tryParse(url);
    return (parsedUri != null && parsedUri.isAbsolute) ? parsedUri : null;
  }

  Uri? getWithKeys(Map<String, dynamic>? obj, List<String> keys) =>
      keys.map((key) => getNullable(obj, key)).firstWhereOrNull((value) => value != null);
}

