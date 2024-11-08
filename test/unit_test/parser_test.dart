import 'package:flutter_test/flutter_test.dart';
import 'package:utils_kit/src/parser.dart';

void main() {
  group('IntParser', () {
    test('get - retrieves int value', () {
      final obj = {'key': 123};
      expect(Parser.int.get(obj, 'key'), 123);
    });

    test('get - returns default value for missing key', () {
      final obj = {'otherKey': 456};
      expect(Parser.int.get(obj, 'key', defaultValue: 99), 99);
    });

    test('getNullable - retrieves int value or null', () {
      final obj = {'key': 123};
      expect(Parser.int.getNullable(obj, 'key'), 123);
      expect(Parser.int.getNullable(obj, 'missingKey'), isNull);
    });

    test('get - converts double and string to int', () {
      final obj = {'doubleKey': 123.45, 'stringKey': '678'};
      expect(Parser.int.get(obj, 'doubleKey'), 123);
      expect(Parser.int.get(obj, 'stringKey'), 678);
    });

    test('getWithKeys - retrieves first matching key', () {
      final obj = {'firstKey': 111, 'secondKey': 222};
      expect(Parser.int.getWithKeys(obj, ['missingKey', 'secondKey']), 222);
    });
  });

  group('DoubleParser', () {
    test('get - retrieves double value', () {
      final obj = {'key': 123.45};
      expect(Parser.double.get(obj, 'key'), 123.45);
    });

    test('get - converts int and string to double', () {
      final obj = {'intKey': 123, 'stringKey': '456.78'};
      expect(Parser.double.get(obj, 'intKey'), 123.0);
      expect(Parser.double.get(obj, 'stringKey'), 456.78);
    });

    test('getWithKeysNullable - returns first non-null double or null', () {
      final obj = {'secondKey': 1.23};
      expect(Parser.double.getWithKeysNullable(obj, ['missingKey', 'secondKey']), 1.23);
    });
  });

  group('StringParser', () {
    test('get - retrieves string value', () {
      final obj = {'key': 'hello'};
      expect(Parser.string.get(obj, 'key'), 'hello');
    });

    test('get - converts int and double to string', () {
      final obj = {'intKey': 123, 'doubleKey': 456.78};
      expect(Parser.string.get(obj, 'intKey'), '123');
      expect(Parser.string.get(obj, 'doubleKey'), '456.78');
    });

    test('getWithKeysNullable - returns first non-null string or null', () {
      final obj = {'secondKey': 'world'};
      expect(Parser.string.getWithKeysNullable(obj, ['missingKey', 'secondKey']), 'world');
    });
  });

  group('ListParser', () {
    test('get - retrieves list value', () {
      final obj = {'key': [1, 2, 3]};
      expect(Parser.list.get(obj, 'key'), [1, 2, 3]);
    });

    test('get - returns default list for missing key', () {
      final obj = {'otherKey': []};
      expect(Parser.list.get(obj, 'key'), []);
    });

    test('getWithKeys - retrieves first non-null list', () {
      final obj = {'secondKey': [4, 5, 6]};
      expect(Parser.list.getWithKeys(obj, ['missingKey', 'secondKey']), [4, 5, 6]);
    });
  });

  group('MapParser', () {
    test('get - retrieves map value', () {
      final obj = {'key': {'innerKey': 'value'}};
      expect(Parser.map.get(obj, 'key'), {'innerKey': 'value'});
    });

    test('getWithKeysNullable - returns first non-null map or null', () {
      final obj = {'secondKey': {'anotherKey': 'anotherValue'}};
      expect(Parser.map.getWithKeysNullable(obj, ['missingKey', 'secondKey']), {'anotherKey': 'anotherValue'});
    });
  });

  group('DateTimeParser', () {
    test('getNullable - parses int as DateTime', () {
      final obj = {'key': 1609459200}; // Unix timestamp for 2021-01-01 00:00:00 UTC
      expect(Parser.dateTime.getNullable(obj, 'key'), DateTime.fromMillisecondsSinceEpoch(1609459200 * 1000));
    });

    test('getNullable - parses valid ISO date string', () {
      final obj = {'key': '2021-01-01T00:00:00.000Z'};
      expect(Parser.dateTime.getNullable(obj, 'key'), DateTime.parse('2021-01-01T00:00:00.000Z'));
    });

    test('getWithKeysNullable - retrieves first valid DateTime or null', () {
      final obj = {'secondKey': '2022-01-01T00:00:00.000Z'};
      expect(Parser.dateTime.getWithKeysNullable(obj, ['missingKey', 'secondKey']), DateTime.parse('2022-01-01T00:00:00.000Z'));
    });
  });

  group('BoolParser', () {
    test('get - retrieves bool value', () {
      final obj = {'key': true};
      expect(Parser.bool.get(obj, 'key'), true);
    });

    test('get - converts string "true"/"false" to bool', () {
      final obj = {'trueKey': 'true', 'falseKey': 'false'};
      expect(Parser.bool.get(obj, 'trueKey'), true);
      expect(Parser.bool.get(obj, 'falseKey'), false);
    });

    test('getWithKeys - retrieves first matching boolean', () {
      final obj = {'secondKey': false};
      expect(Parser.bool.getWithKeys(obj, ['missingKey', 'secondKey']), false);
    });
  });

  group('_UrlParser', () {
    final urlParser = Parser.url;

    test('getNullable - returns Uri for valid URL string', () {
      final obj = {'url': 'https://example.com'};
      final result = urlParser.getNullable(obj, 'url');
      expect(result, isA<Uri>());
      expect(result.toString(), 'https://example.com');
    });

    test('getNullable - returns null for empty string', () {
      final obj = {'url': ''};
      final result = urlParser.getNullable(obj, 'url');
      expect(result, isNull);
    });

    test('getNullable - returns null for invalid URL string', () {
      final obj = {'url': 'not a valid url'};
      final result = urlParser.getNullable(obj, 'url');
      expect(result, isNull);
    });

    test('getNullable - returns null if key is missing', () {
      final obj = {'anotherKey': 'https://example.com'};
      final result = urlParser.getNullable(obj, 'url');
      expect(result, isNull);
    });

    test('getWithKeys - returns Uri for the first valid URL in list of keys', () {
      final obj = {'url1': 'invalid url', 'url2': 'https://valid-url.com'};
      final result = urlParser.getWithKeys(obj, ['url1', 'url2']);
      expect(result, isA<Uri>());
      expect(result.toString(), 'https://valid-url.com');
    });

    test('getWithKeys - returns null if no keys have a valid URL', () {
      final obj = {'url1': 'invalid url', 'url2': 'another invalid url'};
      final result = urlParser.getWithKeys(obj, ['url1', 'url2']);
      expect(result, isNull);
    });

    test('getWithKeys - returns null if none of the keys are present', () {
      final obj = {'anotherKey': 'https://example.com'};
      final result = urlParser.getWithKeys(obj, ['url1', 'url2']);
      expect(result, isNull);
    });
  });
}
