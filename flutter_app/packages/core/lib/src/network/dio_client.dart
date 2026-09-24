import 'package:dio/dio.dart';

/// HTTP client shell. Interceptors are intentionally absent in phase 0.
class DioClient {
  DioClient({Dio? dio}) : dio = dio ?? Dio();

  final Dio dio;
}
