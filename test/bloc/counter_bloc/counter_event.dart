part of 'counter_bloc.dart';

///
/// all of this could be a simple enum
abstract class CounterEvent extends Equatable {
  const CounterEvent();
}

class Increment extends CounterEvent {
  final String description;

  const Increment(this.description);

  @override
  // TODO: implement props
  List<Object> get props => <Object>[description];
}

class Decrement extends CounterEvent {
  final String description;

  const Decrement(this.description);

  @override
  // TODO: implement props
  List<Object> get props => const <Object>[];
}
