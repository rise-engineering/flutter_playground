import 'package:flutter_test/flutter_test.dart';
import 'package:dartup_test/dartup_test.dart';
import 'shared_classes.dart';

///
/// #############Test###############
///

class MockColorClient extends Mock implements ColorClient {}

void main() {
  late MockColorClient mockColorClient;
  late ColorService colorService;
  // before each tests
  setUp(() async {
    mockColorClient = MockColorClient();
    colorService = ColorService(mockColorClient);
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
              when<Color>(() => mockColorClient.findAny())
                  .thenAnswer((_) => Color('fakeCode', 'fakeName'));
              // act
              final result = colorService.selectRandomColor();
              // assert
              expect(result, matches('.*fakeName.*fakeCode'));
              verify(() => mockColorClient.findAny());
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
              // arrange
              when(() => mockColorClient.findByName(any()))
                  .thenAnswer((_) => Color('fakeCode', 'fakeName'));
              // act
              final result = colorService.selectColorByName('fakeCode');
              // assert
              expect(result, matches('.*fakeName.*fakeCode'));
              verify(() => mockColorClient.findByName(captureAny()))
                  .and
                  .expectCapturedToBe(['fakeCode']);
            },
          );
        },
      );
    },
  );
}
