import 'package:flutter_test/flutter_test.dart';

enum TestEnum { A, B }

void main() {
  test(
    'should be B',
    () async {
      // arrange
      final b = TestEnum.B;
      // assert
      expect(b, isNotNull);
      expect(b, TestEnum.B);
      expect(b, isNot(TestEnum.A));
    },
  );
}
