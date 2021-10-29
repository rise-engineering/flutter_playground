import 'package:bloc/bloc.dart';

class InitialEmitterCubit extends Cubit<int> {
  InitialEmitterCubit({
    Duration? delayed,
  }) : super(0) {
    if (delayed == null) {
      emit(2);
      emit(200);
    } else {
      Future.delayed(
        delayed != null ? delayed : Duration(),
        () => emit(1),
      ) //
          .then((_) => emit(100));
    }
  }
}
