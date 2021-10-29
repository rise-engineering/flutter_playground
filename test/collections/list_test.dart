import 'package:dartup_test/dartup_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'verify a list',
    () async {
      // arrange
      final nums = [1, 2, 3] //
          .map((e) => e * 2);
      //standard match
      expect(nums, isNotNull);
      expect(nums, isNotEmpty);
      expect(nums, hasLength(3));
      expect(nums, [2, 4, 6]);
      expect(nums, isNot(same([2, 4, 6])));
      //one match
      expect(nums, contains(6));
      expect(nums, allOf(contains(6), contains(2)));
      //all match
      expect(nums, containsAll([4, 2, 6]));
      expect(nums, containsAllInOrder([2, 4, 6]));

      expect(nums, orderedEquals([2, 4, 6]));
      expect(nums, unorderedMatches([2, 4, 6]));
      expect(nums, unorderedEquals([4, 2, 6]));

      //some match
      expect(nums, containsSomeOf([4, 2]));
    },
  );
}
