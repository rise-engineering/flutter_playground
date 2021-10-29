import 'package:bloc/bloc.dart';

abstract class TestDependency {
  void toCall(int s);
}

class CounterCubit extends Cubit<int> {
  CounterCubit([this.testDependency]) : super(0);

  final TestDependency? testDependency;

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);

  @override
  void onChange(Change<int> change) {
    testDependency?.toCall(change.nextState);
    super.onChange(change);
  }
}
