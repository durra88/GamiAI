import 'package:core/src/domain/failure.dart';
import 'package:dio/dio.dart';

/// Maps a [DioException] to a domain [Failure].
///
/// When [DioException.error] is already a [Failure], that instance is
/// returned. The 401 refresh interceptor uses this to publish
/// [UnauthorizedFailure].
Failure mapDioException(DioException exception) {
  final error = exception.error;
  if (error is Failure) {
    return error;
  }

  final details = exception.message;
  if (_isTransportFailure(exception.type)) {
    return NetworkFailure(technicalDetails: details);
  }

  if (exception.error is FormatException) {
    return ParsingFailure(technicalDetails: exception.error.toString());
  }

  if (exception.type == DioExceptionType.badResponse) {
    return _fromStatus(exception.response?.statusCode, details);
  }

  return UnknownFailure(technicalDetails: details);
}

bool _isTransportFailure(DioExceptionType type) {
  return type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.sendTimeout ||
      type == DioExceptionType.receiveTimeout ||
      type == DioExceptionType.connectionError;
}

Failure _fromStatus(int? status, String? details) {
  if (status == null) {
    return UnknownFailure(technicalDetails: details);
  }
  return switch (status) {
    401 => UnauthorizedFailure(technicalDetails: details),
    403 => ForbiddenFailure(technicalDetails: details),
    404 => NotFoundFailure(technicalDetails: details),
    409 => ConflictFailure(technicalDetails: details),
    400 || 422 => ValidationFailure(technicalDetails: details),
    >= 500 && < 600 => ServerFailure(technicalDetails: details),
    _ => UnknownFailure(technicalDetails: details),
  };
}
