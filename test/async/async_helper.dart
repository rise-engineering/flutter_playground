class CustomTestException implements Exception {
  CustomTestException([this._message = '']);

  final String _message;

  @override
  String toString() {
    return _message;
  }
}

extension StreamExtension<T> on Stream<T> {
  Stream<T> mergeWith(Stream<T> streamAfter) {
    return Stream.fromIterable([this, streamAfter]) //
        .asyncExpand((event) => event);
  }

  Stream<T> doOnEach(void Function(T item) sideEffect) {
    return map((t) {
      sideEffect(t);
      return t;
    });
  }
}
