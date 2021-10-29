import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../counter_cubit/counter_cubit.dart';

part 'counter_event.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc([this.testDependency]) : super(0);
  final TestDependency? testDependency;

  @override
  Stream<int> mapEventToState(
    CounterEvent event,
  ) {
    if (event is Increment) {
      return Stream.value(state + 1);
    } else if (event is Decrement) {
      return Stream.value(state - 1);
    }
    return Stream.empty();
  }

  @override
  void onChange(Change<int> change) {
    testDependency?.toCall(change.nextState);
    super.onChange(change);
  }
}
