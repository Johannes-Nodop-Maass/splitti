extension IterableCommons<T> on Iterable<T> {
  List<E> mapList<E>(E Function(T) toElement) => map(toElement).toList();

  List<T> whereList(bool Function(T _) test) => where(test).toList();

  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert) sync* {
    var index = 0;
    for (var element in this) {
      yield convert(index++, element);
    }
  }

  List<E> mapListIndexed<E>(E Function(int, T) convert) =>
      mapIndexed(convert).toList();
}
