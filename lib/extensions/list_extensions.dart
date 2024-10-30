typedef GetValue<E, T> = T Function(E element);

extension ListUtils<T> on List<T> {

  T? getOrNull(int index) {
    if (index.isNegative) return null;
    if (length < 1) return null;
    if (index > length - 1) {
      return null;
    }
    return this[index];
  }
  T? get firstOrNull {
    if (isNotEmpty) return first;
    return null;
  }

  T? get lastOrNull {
    if (isEmpty) return null;
    if (length == 1) return first;
    return last;
  }

  List<T> intersperse(T element) => _intersperse(element, this).toList();

  Iterable<T> _intersperse(T element, Iterable<T> iterable) sync* {
    final iterator = iterable.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield element;
        yield iterator.current;
      }
    }
  }

  List<T> sortSelf([int Function(T a, T b)? compare]) {
    if (isNotEmpty) {
      sort(compare);
    }
    return this;
  }

  List<T> removeWhereSelf(bool Function(T element) test) {
    if (isNotEmpty) {
      removeWhere(test);
    }
    return this;
  }

  bool containsIndex(int index) => index.isNegative ? false :  index <= (length - 1);

  List<List<T>> toChunks(int chunkSize) {
    final chunks = <List<T>>[];

    for (var i = 0; i < length; i += chunkSize) {
      final end = (i + chunkSize < length) ? i + chunkSize : length;
      chunks.add(sublist(i, end));
    }

    return chunks;
  }

  Map<K, List<T>> groupListsBy<K>(K Function(T element) keyOf) {
    var result = <K, List<T>>{};
    for (var element in this) {
      (result[keyOf(element)] ??= []).add(element);
    }
    return result;
  }



  Map<TKey, TVal> toMap<TKey, TVal>(GetValue<T, TKey> getKey, GetValue<T, TVal> getVal) {
    return {for (final e in this) getKey(e): getVal(e)};
  }
}