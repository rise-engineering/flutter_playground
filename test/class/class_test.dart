import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

class EquatableApple extends Equatable {
  final String name;
  final String color;

  EquatableApple({required this.name, required this.color});

  @override
  List<dynamic> get props => const <dynamic>[];
}

class EquatableRectangle extends Equatable {
  final int aSide;
  final int bSide;

  EquatableRectangle(this.aSide, this.bSide);

  @override
  List<int> get props => <int>[aSide, bSide];
}

///
/// #############Test###############
///
void main() {
  test(
    '2 Apple with the different properties match if the equatable is empty',
    () async {
      // arrange
      final pinkLady1 = EquatableApple(name: 'pink lady', color: 'red');
      final joya = EquatableApple(name: 'joya', color: 'green');
      final pinkLady3 = joya;
      // assert
      expect(joya, pinkLady1);
      expect(joya, equals(pinkLady1));
      expect(joya, same(pinkLady3));
    },
  );

  test(
    '2 rectangle with the same property should match',
    () async {
      // arrange
      final a = EquatableRectangle(1, 3);
      final b = EquatableRectangle(1, 3);
      final c = b;
      // assert
      expect(b, a);
      expect(b, equals(a));
      expect(b, same(c));
    },
  );
}
