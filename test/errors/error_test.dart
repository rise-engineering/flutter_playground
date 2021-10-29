import 'package:dartup_test/dartup_test.dart';
import 'package:flutter_test/flutter_test.dart';

class CustomTestException implements Exception {}
class CustomTestError extends Error {}
///
///see [throwsFlutterError] a matcher for functions that throw [FlutterError]
///see [throwsAssertionError]  a matcher for functions that throw [AssertionError]
///see [throwsArgumentError] a matcher for functions that throw [ArgumentError].
///see [throwsConcurrentModificationError] aA matcher for functions that throw [ConcurrentModificationError].
///see [throwsCyclicInitializationError] a matcher for functions that throw [CyclicInitializationError].
///see [throwsException] aA matcher for functions that throw [Exception].
///see [throwsFormatException] a matcher for functions that throw [FormatException].
///see [throwsNoSuchMethodError] a matcher for functions that throw [NoSuchMethodError].
///see [throwsNullThrownError] a matcher for functions that throw [NullThrownError].
///see [throwsRangeError] a matcher for functions that throw [RangeError].
///see [throwsStateError] a matcher for functions that throw [StateError].
///see [throwsUnimplementedError] a matcher for functions that throw [UnimplementedError].
///see [throwsUnsupportedError] a matcher for functions that throw [UnsupportedError].
///
///see also Error vs. Exception in https://stackoverflow.com/questions/17315945/error-vs-exception-in-dart
void main() {

  test(
    'should throwsAssertionError',
    () async {
      // arrange
      expect(() {
        assert(false);
        return 1;
      }, throwsAssertionError);
    },
  );

  test(
    'should CustomTestException',
    () async {
      // arrange
      expect(() {
        throw CustomTestException();
      }, hasThrow<CustomTestException>());
    },
  );

  test(
    'should CustomTestError',
        () async {
      // arrange
      expect(() {
        throw CustomTestError();
      }, hasThrow<CustomTestError>());
    },
  );
}
