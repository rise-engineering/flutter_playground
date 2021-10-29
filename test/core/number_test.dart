import 'package:flutter_test/flutter_test.dart';

void main() {
  // tests
  test(
    'should be 1',
    () async {
      // arrange
      final i = 1;
      // assert
      expect(i, isNotNull);
      expect(i, isNotNaN);
      expect(i, 1);
      expect(i, equals(1));
      expect(i, same(1));
      expect(i, isNot(0));
      expect(i, isNot(isZero));

      expect(i, isPositive);
      expect(i, isNot(isNegative));
      // expect(i, isEquals(1));
    },
  );

  test(
    'should be ordered',
    () async {
      // arrange
      final i = 1.0;
      // assert
      expect(i, greaterThan(0));
      expect(i, greaterThanOrEqualTo(0));

      expect(i, isNot(lessThan(0)));
      expect(i, isNot(lessThanOrEqualTo(0)));

      expect(i, isNot(inOpenClosedRange(1, 10)));
      expect(i, inClosedOpenRange(1, 10));
      expect(i, isNot(inExclusiveRange(1, 10)));
      expect(i, inInclusiveRange(1, 10));
      expect(i, closeTo(5, 4));
    },
  );
}
