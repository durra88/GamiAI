/// Token persistence shell. Storage is not implemented in phase 0.
class TokenStorage {
  Future<String?> readAccessToken() async {
    // TODO: read the access token from secure storage.
    return null;
  }

  Future<void> writeAccessToken(String token) async {
    // TODO: persist [token].
  }

  Future<void> clear() async {
    // TODO: delete stored tokens.
  }
}
