import 'package:core/src/network/api_headers.dart';
import 'package:dio/dio.dart';

/// Reads the organization currently in scope, if any.
typedef OrganizationIdReader = String? Function();

/// Sets [ApiHeaders.organizationId] when an organization is selected.
final class OrganizationInterceptor extends Interceptor {
  new(this._readOrganizationId);

  final OrganizationIdReader _readOrganizationId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final organizationId = _readOrganizationId();
    if (organizationId != null && organizationId.isNotEmpty) {
      options.headers[ApiHeaders.organizationId] = organizationId;
    } else {
      options.headers.remove(ApiHeaders.organizationId);
    }
    handler.next(options);
  }
}
