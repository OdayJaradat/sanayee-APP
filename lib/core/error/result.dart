import 'failures.dart';

// custom Result type for handling success/failure (similar to Either)
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T value) ok,
    required R Function(Failure failure) err,
  }) {
    if (this is Ok<T>) {
      return ok((this as Ok<T>).value);
    } else {
      return err((this as Err<T>).failure);
    }
  }
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
}
