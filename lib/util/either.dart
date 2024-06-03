sealed class Either<T, V> {
  bool isLeft() => this is Left<T, V>;
  T leftResult() => (this as Left<T, V>).result;

  bool isRight() => this is Right<T, V>;
  V rightResult() => (this as Right<T, V>).result;
}

class Left<T, V> extends Either<T, V> {
  final T result;
  Left(this.result);
}

class Right<T, V> extends Either<T, V> {
  final V result;
  Right(this.result);
}