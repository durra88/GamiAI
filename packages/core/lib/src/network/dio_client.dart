import 'package:core/src/network/auth_interceptor.dart';
import 'package:core/src/network/environment_config.dart';
import 'package:core/src/network/get_retry_interceptor.dart';
import 'package:core/src/network/organization_interceptor.dart';
import 'package:core/src/network/redacting_log_interceptor.dart';
import 'package:core/src/network/refresh_interceptor.dart';
import 'package:core/src/network/request_id_interceptor.dart';
import 'package:core/src/network/token_refresher.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

export 'package:core/src/network/auth_interceptor.dart';
export 'package:core/src/network/organization_interceptor.dart';

/// Builds the shared API client.
///
/// Interceptor registration order is request order. Dio calls `onError` in
/// reverse, so the GET retry observes failures before the 401 refresher.
Dio createDio({
  required EnvironmentConfig config,
  required AccessTokenReader readAccessToken,
  required OrganizationIdReader readOrganizationId,
  TokenRefresher? tokenRefresher,
  Uuid? uuid,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.addAll([
    RequestIdInterceptor(uuid ?? const Uuid()),
    OrganizationInterceptor(readOrganizationId),
    AuthInterceptor(readAccessToken),
    RefreshOnUnauthorizedInterceptor(dio: dio, tokenRefresher: tokenRefresher),
    GetRetryInterceptor(dio),
    if (!config.isProd) RedactingLogInterceptor(),
  ]);

  return dio;
}
