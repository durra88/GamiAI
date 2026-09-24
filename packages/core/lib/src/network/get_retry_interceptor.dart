import 'package:dio/dio.dart';

/// Retries an idempotent GET once.
///
/// POST, PUT, PATCH, DELETE, and auth requests are not retried. They are
/// not idempotent: a second POST can create a duplicate record, and a
/// second login or token refresh can rotate credentials twice. HTTP 401 is
/// also excluded so the refresh interceptor owns that status.
final class GetRetryInterceptor extends Interceptor {
  new(this._dio);

  static const retriedKey = 'retriedIdempotentGet';

  final Dio _dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final alreadyRetried = options.extra[retriedKey] == true;
    if (alreadyRetried || !_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    options.extra[retriedKey] = true;
    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    }
  }

  bool _shouldRetry(DioException err) {
    if (err.requestOptions.method.toUpperCase() != 'GET') {
      return false;
    }
    final type = err.type;
    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.connectionError) {
      return true;
    }
    final status = err.response?.statusCode;
    return status == 502 || status == 503 || status == 504;
  }
}
