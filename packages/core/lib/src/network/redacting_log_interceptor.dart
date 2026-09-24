import 'dart:developer';

import 'package:core/src/network/api_headers.dart';
import 'package:core/src/network/environment_config.dart';
import 'package:dio/dio.dart';

/// Logs method, URI, and status. Redacts [ApiHeaders.authorization].
///
/// Registered only when [EnvironmentConfig.isProd] is false. Request and
/// response bodies are omitted so credentials in payloads are not logged.
final class RedactingLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '--> ${options.method} ${options.uri} '
      'headers=${_redact(options.headers)}',
      name: 'core.dio',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log(
      '<-- ${response.statusCode} ${response.requestOptions.uri}',
      name: 'core.dio',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri} '
      '${err.type}',
      name: 'core.dio',
    );
    handler.next(err);
  }

  Map<String, Object?> _redact(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      if (key.toLowerCase() == ApiHeaders.authorization.toLowerCase()) {
        return MapEntry(key, 'Bearer <redacted>');
      }
      return MapEntry(key, value);
    });
  }
}
