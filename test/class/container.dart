import 'package:get_it/get_it.dart';

import 'shared_classes.dart';

final sl = GetIt.instance;

Future<void> container() async {
  await GetIt.I.reset();
  // sl.registerFactory(() => null)
  // the oder do not have importance
  sl.registerLazySingleton(() => ColorService(sl.get()));
}
