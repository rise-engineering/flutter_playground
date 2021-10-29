import 'dart:developer' as dev;
import 'dart:math';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    colors: false,
  ),
);

void doNothing<T>(T input) {}

void main() {
  test(
    'print should match',
    () async {
      // arrange
      var nextInt = Random().nextInt(1000);
      // act + assert
      expect(() => print('hello-$nextInt'), prints(contains('hello-$nextInt')));
    },
  );
  test(
    'logger should match',
        () async {
      // arrange
      var nextInt = Random().nextInt(1000);
      // act + assert
      expect(() => logger.i('hello-$nextInt'), prints(contains('hello-$nextInt')));
    },
  );
  test(
    'print should does not match outside the expect callback ',
    () async {
      // arrange
      var nextInt = Random().nextInt(1000);
      // act + assert
      print('hello-$nextInt');
      expect(() => doNothing(null), isNot(prints(contains('hello-$nextInt'))));
    },
  );

  test('log should match', () async {
    // arrange
    var nextInt = Random().nextInt(1000);
    // act + assert
    expect(() => dev.log('hello-$nextInt', level: 10),
        prints(contains('hello-$nextInt')));
  }, skip: 'chek why log do no push in stdout');

  test(
    'not printed should match',
    () async {
      // arrange
      var nextInt = Random().nextInt(1000);
      // act + assert
      expect(() => print('hello'), isNot(prints(contains('hello-$nextInt'))));
    },
  );
}
