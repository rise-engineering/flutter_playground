import 'package:flutter_test/flutter_test.dart';

class Apple {
  final String name;
  final String color;

  Apple({required this.name, required this.color});
}

class Rectangle {
  final int aSide;
  final int bSide;

  Rectangle(this.aSide, this.bSide);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rectangle &&
          runtimeType == other.runtimeType &&
          aSide == other.aSide &&
          bSide == other.bSide;

  @override
  int get hashCode => aSide.hashCode ^ bSide.hashCode;
}

///
/// #############Test###############
///
void main() {
  test(
    '2 Apple with the same property should not match',
    () async {
      // arrange
      final pinkLady1 = Apple(name: 'pink lady', color: 'red');
      final pinkLady2 = Apple(name: 'pink lady', color: 'red');
      final pinkLady3 = pinkLady2;
      // assert
      expect(pinkLady2, isNot(pinkLady1));
      expect(pinkLady2, isNot(equals(pinkLady1)));
      expect(pinkLady2, same(pinkLady3));
    },
  );

  test(
    '2 rectangle with the same property should match',
    () async {
      // arrange
      final a = Rectangle(1, 3);
      final b = Rectangle(1, 3);
      final c = b;
      // assert
      expect(b, a);
      expect(b, equals(a));
      expect(b, same(c));
    },
  );
}
