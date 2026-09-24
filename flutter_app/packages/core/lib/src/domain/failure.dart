/// Base failure type. Subclasses carry the specific case.
sealed class Failure {
  const Failure({this.message});

  final String? message;
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message});
}
