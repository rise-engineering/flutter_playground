import 'package:flutter_test/flutter_test.dart';
import 'package:dartup_test/dartup_test.dart';

void main() {
  test(
    'verify a map',
    () async {
      // arrange

      final numMaps = {'1': 1, '2': 2, '3': 3} //
          .map((k, v) => MapEntry(k, v * 2));
      //standard match
      expect(numMaps, isNotNull);
      expect(numMaps, isNotEmpty);
      expect(numMaps, hasLength(3));
      expect(numMaps, {'1': 2, '2': 4, '3': 6});
      expect(numMaps, isNot(same({'1': 2, '2': 4, '3': 6})));
      expect(numMaps, isNot(same({'1': 2, '2': 4, '3': 6})));
      expect(
        numMaps,
        //can use composition
        allOf(
          containsValue(6),
          containsValue(4),
          containsValue(2),
        ),
      );
      expect(
        numMaps,
        allOf(
          containsPair('3', 6),
          // value can be any matcher
          containsPair('2', inInclusiveRange(0, 10)),
          containsPair('1', 2),
        ),
      );

      //Extension
      expect(
        numMaps,
        allOf(
          containsKey('3'),
          containsKey('1'),
          // ignore: prefer_single_quotes
          containsKey('2'),
        ),
      );
    },
  );

  test(
    'get empty a not existing key',
    () async {
        // arrange
        final map = <String, dynamic>{};
        // assert
      expect(map['anyKey'], null);
    },
  );
}
