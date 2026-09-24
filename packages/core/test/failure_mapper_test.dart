import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final options = RequestOptions(path: '/jobs');

  DioException dioError({
    required DioExceptionType type,
    int? statusCode,
    Object? error,
    String? message,
  }) {
    return DioException(
      requestOptions: options,
      type: type,
      message: message,
      error: error,
      response: statusCode == null
          ? null
          : Response<dynamic>(requestOptions: options, statusCode: statusCode),
    );
  }

  test('maps transport errors to NetworkFailure', () {
    final failure = mapDioException(
      dioError(type: DioExceptionType.connectionTimeout, message: 'timed out'),
    );

    expect(failure, isA<NetworkFailure>());
    expect(failure.retryable, isTrue);
    expect(failure.technicalDetails, 'timed out');
  });

  test('maps HTTP statuses to failure subtypes', () {
    expect(
      mapDioException(
        dioError(type: DioExceptionType.badResponse, statusCode: 401),
      ),
      isA<UnauthorizedFailure>(),
    );
    expect(
      mapDioException(
        dioError(type: DioExceptionType.badResponse, statusCode: 403),
      ),
      isA<ForbiddenFailure>(),
    );
    expect(
      mapDioException(
        dioError(type: DioExceptionType.badResponse, statusCode: 404),
      ),
      isA<NotFoundFailure>(),
    );
    expect(
      mapDioException(
        dioError(type: DioExceptionType.badResponse, statusCode: 409),
      ),
      isA<ConflictFailure>(),
    );
    expect(
      mapDioException(
        dioError(type: DioExceptionType.badResponse, statusCode: 422),
      ),
      isA<ValidationFailure>(),
    );
    expect(
      mapDioException(
        dioError(type: DioExceptionType.badResponse, statusCode: 400),
      ),
      isA<ValidationFailure>(),
    );

    final server = mapDioException(
      dioError(type: DioExceptionType.badResponse, statusCode: 503),
    );
    expect(server, isA<ServerFailure>());
    expect(server.retryable, isTrue);
  });

  test('maps parse and unknown errors', () {
    expect(
      mapDioException(
        dioError(
          type: DioExceptionType.unknown,
          error: const FormatException('bad json'),
        ),
      ),
      isA<ParsingFailure>(),
    );
    expect(
      mapDioException(dioError(type: DioExceptionType.cancel)),
      isA<UnknownFailure>(),
    );
  });

  test('returns a Failure already attached to the exception', () {
    const failure = UnauthorizedFailure(technicalDetails: 'refresh failed');

    expect(
      mapDioException(
        dioError(type: DioExceptionType.badResponse, error: failure),
      ),
      failure,
    );
  });
}
