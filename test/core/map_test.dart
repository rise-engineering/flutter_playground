void main() {
  final maListe = [
    {
      'key1': 'value1',
      'key2': 'value2',
    },
    {
      'key1': 'value1',
      'key2': 'value2',
    }
  ];

  final stringList = <int>[1, 2, 3];

  // final stringList = IntList.range(1, 3) //
  //     .map((e) => e * 2);

  print('maListe $maListe');

  maListe.forEach((element) {
    print('foreach');
  });

  stringList.map((d) {
    print('map string');
    return d;
  }).toList();
  //
  maListe.map((d) {
    print('map 1');
    return d;
    // return d as Map<String, dynamic>;
  }); //
  // .map((Map<String, dynamic> e) => randomFunction(e));

  print('finish');
}

String randomFunction(Map<String, dynamic> map) {
  print('ok');
  print('map : $map');
  return '';
}
