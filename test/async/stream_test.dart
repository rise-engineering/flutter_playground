import 'dart:async';

import 'package:dartup_test/dartup_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedantic/pedantic.dart';

import 'async_helper.dart';

void main() {
  test(
    'cannot be consumed several times',
    () async {
      // arrange
      final numStream = Stream.fromIterable([1, 2, 3]) //
          .map((e) => e * 2); //
      //standard match
      await numStream.toList();
      await expectLater(() => numStream.toList(), throwsStateError);
      await expectLater(numStream, isNotNull);
    },
  );
  test(
    'hot - advance stream controlling: emission cannot listen before the subscription time',
    () {
      var controller = StreamController<int>.broadcast(); // assembly
      // controller.add(1);
      final numStream = controller.stream; // assembly
      expectLater(numStream, emitsInOrder([1, 2])); // subscription-1 time
      controller.add(1); // subscription time
      expectLater(numStream, emitsInOrder([2])); // subscription-2 time
      controller.add(2); // subscription time
      controller.close();
      numStream.isBroadcast;
      expect(
        expectLater(numStream, emits(1)), // subscription-3 time
        throwsTestFailure(contains('Which: emitted x Stream closed.')),
      );
    },
  );

  test(
    'hot - periodic',
    () async {
      final stream = Stream.periodic(Duration(milliseconds: 500), (i) => i)
          .asBroadcastStream();
      stream.listen(print);
      await expectLater(stream, emitsInOrder([0, 1]));
      unawaited(expectLater(
          stream, emitsInOrder([2, 3]))); // Explicitly-ignored fire-and-forget.
      await Future.delayed(Duration(seconds: 1));
    },
  );

  test(
    'cold - can be broadcast to be listen(subscribed) several times',
    () {
      // arrange
      var broadcastStream = Stream.value(1).asBroadcastStream();
      broadcastStream.listen(print);
      broadcastStream.listen(print);
      expectLater(broadcastStream, emits(1));
      expectLater(broadcastStream, emits(1));
    },
  );

  test(
    'is empty',
    () async {
      await expectLater(Stream.empty(), isEmptyStream);
      await expectLater(Stream.empty(), emitsNothing);
      await expectLater(Stream.empty(), emitsDone);
      await expectLater(Future.value().asStream(), emits(null));
    },
  );

  test(
    'count',
    () async {
      await expectLater(Stream.fromIterable([1, 90]), countOf(2));
    },
  );

  test(
    'all match',
    () async {
      await expectLater(Stream.fromIterable([2, 2]), emits(2));
      await expectLater(Stream.fromIterable([1, 90]), emits(lessThan(100)));
    },
  );
  test(
    'all match expectLater',
    () async {
      await expectLater(Stream.fromIterable([2, 2]), emits(emits(2)));
    },
  );
  test(
    'always match',
    () async {
      await expectLater(Stream.fromIterable([2, 1]), mayEmit(3));
      await expectLater(Stream.fromIterable([2, 1]), mayEmitMultiple(3));
      await expectLater(Stream.fromIterable([1, 90]), mayEmit(lessThan(100)));
    },
  );
  test(
    'one match',
    () async {
      await expectLater(Stream.fromIterable([2, 1]), emitsThrough(2));
      await expectLater(
          Stream.fromIterable([1, 90]), emitsThrough(lessThan(100)));
    },
  );
  test(
    'never emit',
    () async {
      await expectLater(Stream.fromIterable([2, 1]), neverEmits(3));
      await expectLater(Stream.fromIterable([2, 1]), neverEmits(999));
      await expectLater(Stream.fromIterable([1, 90]), neverEmits(lessThan(0)));
    },
  );
  test(
    'order expectLater',
    () async {
      await expectLater(
          Stream.fromIterable([1, 3, 90]),
          emitsInAnyOrder([
            emits(3),
            emits(anything),
            emits(matcher('to be pair', (i, _) => i % 2 == 0)),
          ]));
    },
  );

  test(
    'order',
    () async {
      await expectLater(
          Stream.fromIterable([1, 3, 90]),
          emitsInAnyOrder([
            3,
            1,
            matcher('to be pair', (i, _) => i % 2 == 0),
          ]));
    },
  );
  test(
    'emitsErrorOfType',
    () async {
      final stream = Stream.error(CustomTestException('some fake message'));
      await expectLater(stream, emitsErrorOfType<CustomTestException>());
    },
  );

  test(
    'mix of error and data',
    () async {
      final stream = Stream.value(1) //
          .mergeWith(Stream.error(CustomTestException('some fake message')));
      await expectLater(
          stream, emitsInOrder([1, emitsErrorOfType<CustomTestException>()]));
    },
  );

  test(
    'error message',
    () async {
      final stream = Stream.value(1) //
          .asyncExpand((event) =>
              Stream.error(CustomTestException('some fake message')));
      await expectLater(
          stream,
          emitsError(matcher('to be CustomTestException with message', (e, _) {
            if (e is CustomTestException) {
              return e.toString() == 'some fake message';
            }
            return false;
          })));
    },
  );

  test(
    'Advanced stream - faking Stream.fromIterable',
    () async {
      var streamController = StreamController<int>();
      streamController.onListen = () {
        [1, 3, 90].forEach((int element) async {
          streamController.add(element);
        });
      };
      var broadStream = streamController.stream.asBroadcastStream();
      await expectLater(broadStream, emitsInOrder([1, 3, 90]));
      await streamController
          .close(); // if I do not close second subscription will go infinite lopp
      expect(
        expectLater(broadStream, emitsInOrder([1, 3, 90])),
        // subscription-3 time
        throwsTestFailure(contains('Which: emitted x Stream closed.')),
      );
    },
  );

  test(
    'Advanced stream - faking Stream.fromIterable with broadcasting -- cold stream create emit same event a the subscription only',
    () async {
      var streamController = StreamController<int>.broadcast();
      streamController.onListen = () {
        [1, 3, 90].forEach((element) async {
          streamController.add(element);
        });
      };
      await expectLater(streamController.stream, emitsInOrder([1, 3, 90]));
      await expectLater(streamController.stream, emitsInOrder([1, 3, 90]));
      await streamController.close();
    },
  );

  test(
    'Advanced stream - pause',
    () async {
      final delay = (int m) => Future.delayed(Duration(milliseconds: m));
      final streamController = StreamController<int>.broadcast();
      final observer = StreamController<int>();

      final subscription = streamController.stream //
          .doOnEach((item) => observer.add(item))
          .listen(print);

      streamController.onCancel = () => observer.close();

      unawaited(expectLater(observer.stream, emitsInOrder([1, 2, 3])));
      streamController.add(1);
      // buffering unit further notice
      subscription.pause();
      streamController.add(2);
      subscription.resume();
      streamController.add(3);
      await delay(500);
      await subscription.cancel();
      streamController.add(4);
    },
  );

  test('Infinite stream', () async {
    // final delay = (int m) => Future.delayed(Duration(milliseconds: m));
    final infiniteStreamGen = () async* {
      var i = 0;
      while (true) {
        i++;
        print(i);
        yield i;
      }
    };
    var infiniteStream = StreamController<int>.broadcast();
    unawaited(infiniteStream.addStream(infiniteStreamGen()));
    // it is hot
    // Stream<int> infiniteStream = infiniteStreamGen().asBroadcastStream();
    unawaited(expectLater(infiniteStream.stream, countOf(10)));
    // expectLater(infiniteStream.stream, emitsInOrder([1, 2, 3]));
  }, skip: true);
}
