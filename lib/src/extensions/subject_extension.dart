import 'package:rxdart/rxdart.dart';

extension SubjectExtension<T> on Subject<T> {
  void safeAdd(T event) {
    if (!isClosed) {
      add(event);
    }
  }
}
