import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler;

void main() {
  late MockRequestInterceptorHandler handler;

  setUp(() {
    handler = MockRequestInterceptorHandler();
  });

  test('sets the organization header when an id is present', () {
    final interceptor = OrganizationInterceptor(() => 'org-1');
    final options = RequestOptions(path: '/jobs');

    interceptor.onRequest(options, handler);

    expect(options.headers[ApiHeaders.organizationId], 'org-1');
    verify(() => handler.next(options)).called(1);
  });

  test('omits the organization header when the id is null', () {
    final interceptor = OrganizationInterceptor(() => null);
    final options = RequestOptions(path: '/jobs');
    options.headers[ApiHeaders.organizationId] = 'stale';

    interceptor.onRequest(options, handler);

    expect(options.headers.containsKey(ApiHeaders.organizationId), isFalse);
    verify(() => handler.next(options)).called(1);
  });
}
