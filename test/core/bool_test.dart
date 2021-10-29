import 'package:flutter_test/flutter_test.dart';
import 'package:dartup_test/dartup_test.dart';

void main() {
  test(
    'should be true',
    () async {
      // arrange
      final b = true;
      // assert
      expect(b, isNotNull);
      expect(b, isTrue);
      expect(b, isNot(isFalse));
      expect(b, anyOf(true, false));
      expect(b, matcher('is not false', (item, _) => item != false));
    },
  );
}
