import 'package:bloc_test/bloc_test.dart';
import 'package:dartup_test/dartup_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'counter_cubit/counter_cubit.dart';
import 'initial_emitter_cubit/initial_emitter_cubit.dart';

class CustomTestException implements Exception {
  CustomTestException([this._message = '']);

  final String _message;

  @override
  String toString() {
    return _message;
  }
}

class MockTestDependency extends Mock implements TestDependency {}

class MockCounterCubit extends MockCubit<int> implements CounterCubit {}

void main() {
  // TODO(nico): fix the test
  late MockTestDependency mockTestDependency;
  late MockCounterCubit mockCounterCubit;

  setUp(() {
    mockTestDependency = MockTestDependency();
    mockCounterCubit = MockCounterCubit();
  });

  test('Cubit init state', () async {
    final CounterCubit counterCubit = CounterCubit();
    // initial state
    expect(counterCubit.state, 0);
  });

  test(
      'Cubit are broadcast stream therefore are open to several times subscription',
      () async {
    final CounterCubit counterCubit = CounterCubit();
    // initial state
    expect(counterCubit.stream,
        emitsInOrder(<int>[0, 10, 2, 20])); // subscription-1
    counterCubit.emit(0);
    counterCubit.emit(10);
    expect(counterCubit.stream, emitsInOrder(<int>[2, 20])); // subscription-1
    counterCubit.emit(2);
    counterCubit.emit(20);
    counterCubit.close();
    expect(
      expectLater(counterCubit.stream, emits(1)), // subscription-3 time
      throwsTestFailure(contains('Which: emitted x Stream closed.')),
    );
  });

  test('Cubit with initial emitter with initial delay can be observed',
      () async {
    final InitialEmitterCubit initialEmitterCubit =
        InitialEmitterCubit(delayed: Duration());
    // initial state
    expectLater(
        initialEmitterCubit.stream,
        emitsInOrder(<int>[
          1,
          100,
        ]));
  });

  test('Cubit with initial emitter with no initial delay can status checked',
      () async {
    final InitialEmitterCubit initialEmitterCubit = InitialEmitterCubit();
    // initial state
    expectLater(initialEmitterCubit.state, 200);
  });

  test('Cubit with initial emitter with no initial delay cannot be observed',
      () async {
    final InitialEmitterCubit initialEmitterCubit = InitialEmitterCubit();
    // initial state
    expectLater(initialEmitterCubit, isEmptyStream);
  }, skip: "cannot be observed");

  test(
    'Cubit is just stream - test with later emission',
    () async {
      final CounterCubit counterCubit = CounterCubit();
      // initial state

      ///
      /// It is usually not be necessary to call expectLater before actually dispatching the event because it takes some time before a Stream emits its first value. I like to err on the safe side though.
      ///
      /// Subscribing to a cubit take some time. The first event could be emitted before the subscribtion is made
      ///
      /// == Assembly time vs Stream run time
      expectLater(
          counterCubit.stream,
          emitsInOrder(<int>[
            1,
            2,
          ]));
      counterCubit.increment();
      counterCubit.increment();
    },

    // skip: 'do no work as expected',
  );

  test(
    'Cubit is just stream - test with future emission',
    () async {
      final CounterCubit counterCubit = CounterCubit();
      // initial state
      Future.microtask(() => counterCubit.increment())
          .then((_) => counterCubit.increment());

      expectLater(
          counterCubit.stream,
          emitsInOrder(<int>[
            1,
            2,
          ]));
    },
  );

  test(
    'Cubit is just broadcast stream - Try to emit before subscription miss events',
    () async {
      final CounterCubit counterCubit = CounterCubit();
      // initial state
      counterCubit.increment();
      counterCubit.increment();
      expectLater(counterCubit.stream, emitsNothing);
      counterCubit.close(); // should be closed to avoid infinite loop
    },
  );

  test(
    'Cubit is just broadcast stream - Try consumed after close',
    () async {
      final CounterCubit counterCubit = CounterCubit();
      final Stream<int> counterStream = counterCubit.stream.asBroadcastStream();
      // initial state
      expectLater(counterCubit.stream, emitsInOrder(<int>[1, 2]));
      counterCubit.increment();
      counterCubit.increment();
      // expectLater(counterStream, emitsInOrder([1,2]));
      counterCubit.close(); // should be closed to avoid infinite loop
      expectLater(counterStream, emitsNothing);
      counterCubit.increment();
    },
  );

  test(
    'State of a closed cubit is immutable',
    () async {
      final CounterCubit counterCubit = CounterCubit();
      counterCubit.emit(1000);
      counterCubit.close(); // should be closed to avoid infinite loop
      counterCubit.increment();
      counterCubit.increment();
      expect(counterCubit.state, 1000);
    },
  );

  /// Creates a new `cubit`-specific test case with the given [description].
  /// [blocTest] will handle asserting that the `cubit` emits the [expect]ed
  /// states (in order) after [act] is executed.
  /// [blocTest] also handles ensuring that no additional states are emitted
  /// by closing the `cubit` stream before evaluating the [expect]ation.
  blocTest(
    'blocTest in action',
    build: () => CounterCubit(),
    act: (CounterCubit bloc) {
      bloc.increment();
      bloc.increment();
      bloc.increment();
      bloc.decrement();
      bloc.increment();
    },
    expect: () => <int>[1, 2, 3, 2, 3],
  );

  blocTest(
    'emitting multiple times the same events keep only one',
    build: () => CounterCubit(),
    act: (CounterCubit bloc) {
      bloc.emit(1);
      bloc.emit(1);
      bloc.emit(1);
      bloc.emit(1);
      bloc.emit(1);
      bloc.emit(1);
    },
    expect: () => <int>[1],
  );

  blocTest<CounterCubit, int>(
    'blocTest in action with error',
    build: () => CounterCubit(),
    act: (CounterCubit bloc) {
      bloc.increment();
      bloc.addError(CustomTestException('fake'));
      bloc.increment();
      bloc.decrement();
      bloc.increment();
    },
    expect: () => <int>[1],
    errors: () => [
      isA<CustomTestException>(),
    ],
  );

  blocTest('blocTest in action with mock',
      build: () => CounterCubit(mockTestDependency),
      act: (CounterCubit bloc) {
        bloc.increment();
        bloc.decrement();
        bloc.decrement();
        bloc.increment();
      },
      expect: () => <int>[1, 0, -1, 0],
      verify: (_) => verify(() => mockTestDependency.toCall(captureAny()))
          .and
          .expectCapturedToBe(<int>[1, 0, -1, 0]));

  test(
    'block mocked with emission',
    () async {
      // arrange
      whenListen(mockCounterCubit, Stream.fromIterable(<int>[0, 1, 2, 3]));
      // assert
      // Mandatory await to check the last state
      await expectLater(
          mockCounterCubit.stream, emitsInOrder(<int>[0, 1, 2, 3]));
      expect(mockCounterCubit.state, equals(3));
    },
  );
}
