import 'package:bloc_test/bloc_test.dart';
import 'package:dartup_test/dartup_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'counter_bloc/counter_bloc.dart';
import 'counter_cubit/counter_cubit.dart';

/// Also see https://resocoder.com/2019/11/29/bloc-test-tutorial-easier-way-to-test-blocs-in-dart-flutter/
class CustomTestException implements Exception {
  CustomTestException([this._message = '']);

  final String _message;

  @override
  String toString() {
    return _message;
  }
}

class MockCounterBloc extends MockBloc<CounterEvent, int>
    implements CounterBloc {}

class MockTestDependency extends Mock implements TestDependency {}

class MyFakeCounterEvent extends Fake implements CounterEvent {}

void main() {
  late MockTestDependency mockTestDependency;
  late MockCounterBloc mockCounterBloc;

  setUp(() {
    registerFallbackValue(MyFakeCounterEvent());
    mockTestDependency = MockTestDependency();
    mockCounterBloc = MockCounterBloc();
  });

  test('Cubit init state', () async {
    final counterCubit = CounterCubit();
    // initial state
    expect(counterCubit.state, 0);
  });

  test(
    'Bloc is just stream',
    () async {
      final counterBloc = CounterBloc();

      // initial state
      expect(counterBloc.state, 0);

      /// It is usually not be necessary to call expectLater before actually dispatching the event because it takes some time before a Stream emits its first value. I like to err on the safe side though.
      expectLater(
          counterBloc.stream,
          emitsInOrder(<int>[
            1,
            2,
          ]));

      /// Subscribing to a cubit take some time. The first event could be emitted before the subscribtion is made

      counterBloc.add(Increment('plus'));
      counterBloc.add(Increment('plus'));
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
    'blocTest in action with error',
    build: () => CounterBloc(),
    act: (CounterBloc bloc) {
      bloc.add(Increment('plus'));
      bloc.addError(CustomTestException('fake'));
      bloc.add(Increment('plus'));
      bloc.add(Decrement('moins'));
      bloc.add(Increment('plus'));
    },
    expect: () => [1],
    errors: () => [
      isA<CustomTestException>(),
    ],
  );

  blocTest('blocTest in action with mock',
      build: () => CounterBloc(mockTestDependency),
      act: (CounterBloc bloc) {
        bloc.add(Increment('plus'));
        bloc.add(Decrement('moins'));
        bloc.add(Decrement('moins'));
        bloc.add(Increment('plus'));
      },
      expect: () => [1, 0, -1, 0],
      verify: (_) => verify(() => mockTestDependency.toCall(captureAny()))
          .and
          .expectCapturedToBe([1, 0, -1, 0]));

  test(
    'block mocked with emission',
    () async {
      // arrange
      whenListen(mockCounterBloc, Stream.fromIterable(<int>[0, 1, 2, 3]));
      // assert
      // Mandatory await to check the last state
      await expectLater(
          mockCounterBloc.stream, emitsInOrder(<int>[0, 1, 2, 3]));
      expect(mockCounterBloc.state, equals(3));
    },
  );
}
