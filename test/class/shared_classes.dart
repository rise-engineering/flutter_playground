abstract class Identifiable {
  String get id;
}

abstract class Colored {
  String get color;
}

abstract class Named {
  String get name;
}

abstract class Auditable implements Identifiable {
  DateTime get when;
}

class Color {
  final String hexCode;
  final String name;

  Color(this.hexCode, this.name);

  Color.color({required this.hexCode, required this.name});
}

abstract class ColorClient {
  Color findAny();

  Color findByName(String? name);
}

///
/// This the class we want to test. It has a dependency in [ColorClient]
///
class ColorService {
  final ColorClient _colorClient;

  ColorService(this._colorClient);

  String selectRandomColor() {
    final anyColor = _colorClient.findAny();
    return '${anyColor.name} with the ${anyColor.hexCode} is a randomly selected';
  }

  String selectColorByName(String name) {
    final color = _colorClient.findByName(name);
    return '${color.name} with the ${color.hexCode} is selected';
  }
}
