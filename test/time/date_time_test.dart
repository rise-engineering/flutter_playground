import 'package:dartup_test/dartup_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'isAfter',
    () {
      // tests
      test(
        'should match one dateTime',
        () async {
          // arrange
          final now = DateTime.now();
          final beforeNow = now.subtract(Duration(days: 10));
          // act
          // assert
          expect(now, isAfter(beforeNow));
          expect(beforeNow, isNot(isAfter(now)));
        },
      );
    },
  );

  group(
    'isBefore',
    () {
      // tests
      test(
        'should match one dateTime',
        () async {
          // arrange
          final now = DateTime.now();
          final beforeNow = now.subtract(Duration(days: 10));
          // act
          // assert
          expect(beforeNow, isBefore(now));
          expect(now, isNot(isBefore(beforeNow)));
        },
      );
    },
  );

  group(
    'isCloseTo',
    () {
      // tests
      test(
        'should match one dateTime',
        () async {
          // arrange
          final now = DateTime.now();
          final beforeNow = now.subtract(Duration(days: 10));
          // act
          // assert
          expect(now, isCloseTo(beforeNow, days: 10));
          expect(now, isCloseTo(beforeNow, days: 12));
          expect(beforeNow, isCloseTo(now, days: 10));
          expect(beforeNow, isCloseTo(now, days: 12));
          expect(now, isNot(isCloseTo(beforeNow)));
        },
      );
      test(
        'should match one dateTime with wait',
        () async {
          // arrange
          final beforeNow = DateTime.now();
          await Future.delayed(Duration(milliseconds: 500));
          final now = DateTime.now();
          // act
          // assert
          expect(now, isCloseTo(beforeNow, milliseconds: 600));
          expect(now, isNot(isCloseTo(beforeNow, milliseconds: 400)));
        },
      );
    },
  );
}
