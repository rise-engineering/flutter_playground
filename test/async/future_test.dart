import 'package:flutter_test/flutter_test.dart';

Future<int> myFuture(Future<int> inputFuture) async {
  return await inputFuture;
}

void main() {
  test(
    'future is like promises is js',
    () async {
      //Create one is easy
      final promiseOfOne = Future.delayed(Duration(seconds: 1), () => 1);

      // compute on it also
      final promiseOfComputedOne = promiseOfOne //
          .then((i) => i * 2) //
          // can take future in then
          .then((i) => Future.value(i * 3));

      // get the promised value is a bit harder. we need to wait
      // testing is easy

      await expectLater(promiseOfOne, completes);
      await expectLater(promiseOfComputedOne, completes);
      await expectLater(promiseOfOne, completion(1));
      await expectLater(promiseOfComputedOne, completion(closeTo(0, 8)));
      await expectLater(promiseOfComputedOne, completion(closeTo(0, 8)));
    },
  );

  test(
    'async function creation a new future',
    () async {
      //Create one is easy
      final promiseOfOne = Future.delayed(Duration(seconds: 1), () => 1);

      // compute on it also
      final returnFuture = myFuture(promiseOfOne);

      // get the promised value is a bit harder. we need to wait
      // testing is easy

      await expectLater(promiseOfOne, completion(1));
      await expectLater(returnFuture, completion(1));
      await expectLater(promiseOfOne, isNot(returnFuture));
      await expectLater(promiseOfOne, isNot(same(returnFuture)));
    },
  );

  test(
    'empty future',
    () async {
      await expectLater(Future.value(), completion(null));
      await expectLater(Future.value(), completes);
    },
  );
}
