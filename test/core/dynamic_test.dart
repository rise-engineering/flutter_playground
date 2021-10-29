import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should be an integer',
    () async {
      // arrange
      final dynamic i = 1;
      // assert
      expect(i, isNotNull);
      expect(i, isA<int>());
      expect(i, isInstanceOf<int>());
      expect(i, isNot(isList));
      expect(i, isNot(isMap));
    },
  );
}
