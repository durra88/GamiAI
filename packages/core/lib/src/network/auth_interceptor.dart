import 'package:core/src/network/api_headers.dart';
import 'package:core/src/network/refresh_interceptor.dart';
import 'package:dio/dio.dart';

/// Reads the current access token, if one is stored.
typedef AccessTokenReader = Future<String?> Function();

/// Sets the bearer token unless this request is the post-refresh retry.
final class AuthInterceptor extends Interceptor {
  new(this._readAccessToken);

  final AccessTokenReader _readAccessToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[RefreshOnUnauthorizedInterceptor.retriedKey] == true) {
      handler.next(options);
      return;
    }

    final token = await _readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers[ApiHeaders.authorization] = 'Bearer $token';
    } else {
      options.headers.remove(ApiHeaders.authorization);
    }
    handler.next(options);
  }
}
