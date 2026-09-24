import 'package:core/src/domain/failure.dart';
import 'package:core/src/network/api_headers.dart';
import 'package:core/src/network/token_refresher.dart';
import 'package:dio/dio.dart';

/// On HTTP 401, refreshes once and retries the original request once.
///
/// A second 401, a null token, or a failed refresh rejects with
/// [UnauthorizedFailure] so the app can force logout.
///
/// This interceptor does not call the refresh endpoint itself.
///
// TODO(phase-auth): TokenRefresher is the seam for the auth package.
final class RefreshOnUnauthorizedInterceptor extends Interceptor {
  new({required this._dio, this._tokenRefresher});

  /// Set on the single retry so the auth interceptor keeps the new token.
  static const retriedKey = 'retriedAfterRefresh';

  final Dio _dio;
  final TokenRefresher? _tokenRefresher;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final alreadyRetried = err.requestOptions.extra[retriedKey] == true;
    if (alreadyRetried || _tokenRefresher == null) {
      handler.reject(_unauthorized(err));
      return;
    }

    try {
      final newToken = await _tokenRefresher.refreshAccessToken();
      if (newToken == null || newToken.isEmpty) {
        handler.reject(_unauthorized(err));
        return;
      }

      final options = err.requestOptions;
      options.extra[retriedKey] = true;
      options.headers[ApiHeaders.authorization] = 'Bearer $newToken';
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (error) {
      if (error.error is UnauthorizedFailure) {
        handler.reject(error);
        return;
      }
      handler.reject(_unauthorized(err, technicalDetails: error.message));
    } on Object catch (error) {
      handler.reject(_unauthorized(err, technicalDetails: error.toString()));
    }
  }

  DioException _unauthorized(DioException err, {String? technicalDetails}) {
    return DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.badResponse,
      message: err.message,
      error: UnauthorizedFailure(
        technicalDetails: technicalDetails ?? err.message,
      ),
    );
  }
}
