import 'package:flutter_test/flutter_test.dart';
import 'package:dartup_test/dartup_test.dart';

void main() {
  group(
    'any string',
    () {
      // tests
      // tests
      test(
        'should be "a_b_c_d"',
        () async {
          // arrange
          final s = 'a_b_c_d';
          // assert
          expect(s, isNotNull);
          expect(s, 'a_b_c_d');
          expect(s, same('a_b_c_d'));
          expect(s, isNot('abcd'));

          expect(s, hasLength(7));

          expect(s, matches('([a-z]_)+[a-z]'));
          expect(s, startsWith('a_'));
          expect(s, endsWith('_d'));
          expect(s, stringContainsInOrder(['a', 'b', 'c', 'd']));
          expect(s, contains('b'));
          // expect(s, containsValue('_b_'));
        },
      );
    },
  );

  group(
    'email',
    () {
      // tests
      test(
        'is an email',
        () async {
          // arrange
          final tEmail = 'a&d@somedomain.com';
          // assert
          expect(tEmail, isEmail);
        },
      );
      test(
        'is not an email',
        () async {
          // arrange
          final tEmail = '.abc@somedomain.com';
          // assert
          expect(tEmail, isNot(isEmail));
        },
      );
    },
  );

  group(
    'url',
    () {
      // tests
      test(
        'should be a url',
        () async {
          // arrange
          final tUrl = 'http://www.google.com/search?q=good+url+regex';
          // assert
          expect(tUrl, isUrl);
        },
      ); // tests
      test(
        'is not an url',
        () async {
          // arrange
          final tUrl = 'htp://google.co';
          // assert
          expect(tUrl, isNot(isUrl));
        },
      );
    },
  );
}
