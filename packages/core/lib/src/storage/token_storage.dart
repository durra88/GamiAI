/// Persists the session tokens used by the API client.
abstract interface class TokenStorage {
  Future<String?> readAccessToken();

  Future<String?> readRefreshToken();

  Future<void> writeTokens({required String accessToken, String? refreshToken});

  Future<void> clearAll();

  Future<bool> hasCredentials();
}
