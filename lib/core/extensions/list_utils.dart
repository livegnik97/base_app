// ignore: unused_import, depend_on_referenced_packages
// import 'package:collection/collection.dart' as collection;

extension ListUtils<T> on List<T> {
  // T? firstWhereOrNull2(bool Function(T element) test) {
  //   return firstWhereOrNull(test);
  // }

  T? firstWhereOrNull(bool Function(T element) test) {
    final index = indexWhere(test);
    return index >= 0 ? this[index] : null;
  }
}
