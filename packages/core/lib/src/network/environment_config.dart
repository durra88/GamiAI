/// Deployment target selected at compile time.
enum AppEnvironment {
  dev,
  staging,
  prod;

  /// Parses `APP_ENV`. Unknown values fall back to [AppEnvironment.dev].
  static AppEnvironment parse(String raw) {
    return switch (raw) {
      'staging' => AppEnvironment.staging,
      'prod' => AppEnvironment.prod,
      _ => AppEnvironment.dev,
    };
  }
}

/// Base URL and environment for the API client.
final class EnvironmentConfig {
  const new({required this.environment, required this.apiBaseUrl});

  /// Reads `APP_ENV` and `API_BASE_URL` from `--dart-define`.
  factory fromDefines() {
    const envName = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
    const baseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );
    return EnvironmentConfig(
      environment: AppEnvironment.parse(envName),
      apiBaseUrl: baseUrl,
    );
  }

  final AppEnvironment environment;
  final String apiBaseUrl;

  bool get isProd => environment == AppEnvironment.prod;
}
