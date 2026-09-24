import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const config = EnvironmentConfig(
    environment: AppEnvironment.prod,
    apiBaseUrl: 'https://example.test',
  );

  test(
    'retries the original request once after a successful refresh',
    () async {
      final calls = <Map<String, dynamic>>[];
      final refresher = _StubRefresher(() async => 'new-token');
      final dio =
          createDio(
              config: config,
              readAccessToken: () async => 'old-token',
              readOrganizationId: () => null,
              tokenRefresher: refresher,
            )
            ..httpClientAdapter = _ScriptedAdapter(
              onFetch: (options) async {
                calls.add(Map<String, dynamic>.from(options.headers));
                final status = calls.length == 1 ? 401 : 200;
                return _body(status);
              },
            );

      final response = await dio.get<dynamic>('/me');

      expect(response.statusCode, 200);
      expect(refresher.calls, 1);
      expect(calls, hasLength(2));
      expect(calls.first[ApiHeaders.authorization], 'Bearer old-token');
      expect(calls.last[ApiHeaders.authorization], 'Bearer new-token');
    },
  );

  test(
    'refresh failure yields UnauthorizedFailure and does not retry',
    () async {
      var fetches = 0;
      final refresher = _StubRefresher(() async => null);
      final dio =
          createDio(
              config: config,
              readAccessToken: () async => 'old-token',
              readOrganizationId: () => null,
              tokenRefresher: refresher,
            )
            ..httpClientAdapter = _ScriptedAdapter(
              onFetch: (options) async {
                fetches += 1;
                return _body(401);
              },
            );

      await expectLater(
        dio.get<dynamic>('/me'),
        throwsA(
          isA<DioException>().having(
            (error) => error.error,
            'error',
            isA<UnauthorizedFailure>(),
          ),
        ),
      );
      expect(refresher.calls, 1);
      expect(fetches, 1);
    },
  );
}

ResponseBody _body(int status) {
  return ResponseBody.fromString(
    '{}',
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

final class _StubRefresher implements TokenRefresher {
  new(this._refresh);

  final Future<String?> Function() _refresh;
  int calls = 0;

  @override
  Future<String?> refreshAccessToken() {
    calls += 1;
    return _refresh();
  }
}

final class _ScriptedAdapter implements HttpClientAdapter {
  new({required this.onFetch});

  final Future<ResponseBody> Function(RequestOptions options) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return onFetch(options);
  }

  @override
  void close({bool force = false}) {}
}
