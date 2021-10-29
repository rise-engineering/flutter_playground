import 'package:dartup_test/dartup_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'base',
    () {
      // tests
      test(
        'should match',
        () async {
          // arrange
          final tenDays = Duration(days: 10);
          final tenDays2 = Duration(days: 10);
          // act
          // assert
          expect(tenDays, isNotNull);
          expect(tenDays, tenDays2);
        },
      );
    },
  );

  group(
    'isLongerThan',
    () {
      // tests
      test(
        'should match one duration',
        () async {
          // arrange
          final tenDays = Duration(days: 10);
          final hundredMilli = Duration(milliseconds: 100);
          // act
          // assert
          expect(tenDays, isLongerThan(hours: 5));
          expect(hundredMilli, isNot(isLongerThan(hours: 5)));
        },
      );

      test(
        'should throw an error if actual is not duration',
        () async {
          // arrange
          expect(() => isLongerThan().matches(1, {}), throwsAssertionError);
        },
      );
    },
  );

  group(
    'isShorterThan',
    () {
      // tests
      test(
        'should match one duration',
        () async {
          // arrange
          final tenDays = Duration(days: 10);
          final hundredMilli = Duration(milliseconds: 100);
          // act
          // assert
          expect(hundredMilli, isShorterThan(hours: 5));
          expect(tenDays, isNot(isShorterThan(hours: 5)));
        },
      );

      test(
        'should throw an error if actual is not duration',
        () async {
          // arrange
          expect(() => isShorterThan().matches(1, {}), throwsAssertionError);
        },
      );
    },
  );
}
