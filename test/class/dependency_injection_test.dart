import 'package:dartup_test/dartup_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'container.dart';
import 'shared_classes.dart';

///
/// #############Test###############
///

class MockColorClient extends Mock implements ColorClient {}

void main() {
  // before each tests
  setUp(() async {
    await container();
    sl.registerLazySingleton<ColorClient>(() => MockColorClient());
  });

  group(
    'ColorService',
    () {
      group(
        'selectRandomColor',
        () {
          // tests
          test(
            'should give a random selection',
            () async {
              // arrange
              final colorClient = sl.get<ColorClient>();
              final colorService = sl.get<ColorService>();

              when(() => colorClient.findAny())
                  .thenAnswer((_) => Color('fakeCode', 'fakeName'));
              // act
              final result = colorService.selectRandomColor();
              // assert
              expect(result, matches('.*fakeName.*fakeCode'));
              verify(() => colorClient.findAny());
            },
          );
        },
      );

      group(
        'selectColorByName',
        () {
          // tests
          test(
            'should give a selection by name',
            () async {
              final colorClient = sl.get<ColorClient>();
              final colorService = sl.get<ColorService>();
              // arrange
              when(() => colorClient.findByName(any()))
                  .thenAnswer((_) => Color('fakeCode', 'fakeName'));
              // act
              var result = colorService.selectColorByName('fakeCode');
              // assert
              expect(result, matches('.*fakeName.*fakeCode'));
              verify(() => colorClient.findByName(captureAny()))
                  .and
                  .expectCapturedToBe(['fakeCode']);
            },
          );
        },
      );
    },
  );
}

void simpleRegister<T extends Object, D extends Object>(T Function(D a) fact) {
  GetIt.I.registerSingletonWithDependencies<T>(() => fact(GetIt.I()),
      dependsOn: [D], signalsReady: false);
}
