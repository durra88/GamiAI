import 'package:core/src/network/api_headers.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// Adds a unique [ApiHeaders.requestId] to every outgoing request.
final class RequestIdInterceptor extends Interceptor {
  new(this._uuid);

  final Uuid _uuid;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiHeaders.requestId] = _uuid.v4();
    handler.next(options);
  }
}
