final di = _Di();

class _Di {
  final Set<dynamic> _di = {};

  void set<T>(T obj) {
    if (_di.any((element) => element.runtimeType == obj.runtimeType)) {
      _di.removeWhere((element) => element.runtimeType == obj.runtimeType);
      _di.add(obj);
      return;
    }

    _di.add(obj);
  }

  T get<T>() => _di.firstWhere((element) => element.runtimeType == T);
}