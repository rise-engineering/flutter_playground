import 'package:flutter_test/flutter_test.dart';

import 'shared_classes.dart';

class User implements Auditable {
  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement when
  DateTime get when => throw UnimplementedError();
}

class Fruit implements Named, Colored {
  @override
  // TODO: implement color
  String get color => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();
}

///
/// #############Test###############
///

void main() {
  test(
    'should be Identifiable',
    () async {
      // arrange
      final user = User();
      // assert
      expect(user, isNotNull);
      expect(user, isA<Identifiable>());
      expect(user, isA<Auditable>());
      expect(user, isA<Identifiable>());
    },
  );

  test(
    'should be Fruit',
    () async {
      // arrange
      final fruit = Fruit();
      // assert
      expect(fruit, isNotNull);
      expect(fruit, isA<Fruit>());
      expect(fruit, isA<Named>());
      expect(fruit, isInstanceOf<Colored>());
    },
  );
}
