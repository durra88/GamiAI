import 'package:core/src/storage/secure_key_value_store.dart';
import 'package:core/src/storage/token_storage.dart';

/// [TokenStorage] that keeps tokens in a [SecureKeyValueStore].
final class SecureTokenStorage implements TokenStorage {
  new(this._store);

  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  final SecureKeyValueStore _store;

  @override
  Future<String?> readAccessToken() => _store.read(accessTokenKey);

  @override
  Future<String?> readRefreshToken() => _store.read(refreshTokenKey);

  @override
  Future<void> writeTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _store.write(accessTokenKey, accessToken);
    if (refreshToken != null) {
      await _store.write(refreshTokenKey, refreshToken);
    }
  }

  @override
  Future<void> clearAll() => _store.deleteAll();

  @override
  Future<bool> hasCredentials() async {
    final accessToken = await readAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}
