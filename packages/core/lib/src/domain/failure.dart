import 'package:core/src/domain/failure_code.dart';
import 'package:equatable/equatable.dart';

/// A recoverable or terminal error from the domain boundary.
///
/// [technicalDetails] is safe for logs and must not be shown to users.
/// [retryable] tells callers whether a transport-level retry is appropriate.
sealed class Failure extends Equatable {
  const new({
    required this.code,
    this.technicalDetails,
    this.retryable = false,
  });

  final FailureCode code;
  final String? technicalDetails;
  final bool retryable;

  @override
  List<Object?> get props => [code, technicalDetails, retryable];
}

/// The request did not reach a usable response because of the network.
final class NetworkFailure extends Failure {
  const new({super.technicalDetails})
    : super(code: FailureCode.network, retryable: true);
}

/// The caller is not authenticated. The app should force logout.
final class UnauthorizedFailure extends Failure {
  const new({super.technicalDetails}) : super(code: FailureCode.unauthorized);
}

/// The caller is authenticated but not allowed to perform the action.
final class ForbiddenFailure extends Failure {
  const new({super.technicalDetails}) : super(code: FailureCode.forbidden);
}

/// The request was rejected because the payload failed validation.
final class ValidationFailure extends Failure {
  const new({super.technicalDetails}) : super(code: FailureCode.validation);
}

/// The requested resource does not exist.
final class NotFoundFailure extends Failure {
  const new({super.technicalDetails}) : super(code: FailureCode.notFound);
}

/// The request conflicts with the current state of the resource.
final class ConflictFailure extends Failure {
  const new({super.technicalDetails}) : super(code: FailureCode.conflict);
}

/// The server failed. Safe to retry for idempotent calls.
final class ServerFailure extends Failure {
  const new({super.technicalDetails})
    : super(code: FailureCode.server, retryable: true);
}

/// The response body could not be decoded.
final class ParsingFailure extends Failure {
  const new({super.technicalDetails}) : super(code: FailureCode.parsing);
}

/// An error that does not match a more specific failure.
final class UnknownFailure extends Failure {
  const new({super.technicalDetails}) : super(code: FailureCode.unknown);
}
