import 'package:core/src/domain/failure.dart';
import 'package:equatable/equatable.dart';

/// The outcome of an operation that can fail with a [Failure].
sealed class Result<T> extends Equatable {
  const new();

  /// Branches on [Success] or [FailureResult].
  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  });
}

/// A successful [Result] holding [value].
final class Success<T> extends Result<T> {
  const new(this.value);

  final T value;

  @override
  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  }) {
    return success(value);
  }

  @override
  List<Object?> get props => [value];
}

/// A failed [Result] holding [failure].
final class FailureResult<T> extends Result<T> {
  const new(this.failure);

  final Failure failure;

  @override
  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  }) {
    return failure(this.failure);
  }

  @override
  List<Object?> get props => [failure];
}
