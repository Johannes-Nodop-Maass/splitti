extension IterableCommons<T> on Iterable<T> {
  List<E> mapList<E>(E Function(T) toElement) => map(toElement).toList();

  List<T> whereList(bool Function(T _) test) => where(test).toList();
}
