import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureKeyValueStore extends Mock implements SecureKeyValueStore;

void main() {
  late MockSecureKeyValueStore store;
  late SecureTokenStorage storage;

  setUp(() {
    store = MockSecureKeyValueStore();
    storage = SecureTokenStorage(store);
  });

  test('writeTokens stores access and refresh tokens', () async {
    when(() => store.write(any(), any())).thenAnswer((_) async {});

    await storage.writeTokens(accessToken: 'access', refreshToken: 'refresh');

    verify(() => store.write(SecureTokenStorage.accessTokenKey, 'access'))
        .called(1);
    verify(() => store.write(SecureTokenStorage.refreshTokenKey, 'refresh'))
        .called(1);
  });

  test('writeTokens skips a null refresh token', () async {
    when(() => store.write(any(), any())).thenAnswer((_) async {});

    await storage.writeTokens(accessToken: 'access');

    verify(() => store.write(SecureTokenStorage.accessTokenKey, 'access'))
        .called(1);
    verifyNever(() => store.write(SecureTokenStorage.refreshTokenKey, any()));
  });

  test('reads tokens and reports credentials', () async {
    when(() => store.read(SecureTokenStorage.accessTokenKey))
        .thenAnswer((_) async => 'access');
    when(() => store.read(SecureTokenStorage.refreshTokenKey))
        .thenAnswer((_) async => 'refresh');

    expect(await storage.readAccessToken(), 'access');
    expect(await storage.readRefreshToken(), 'refresh');
    expect(await storage.hasCredentials(), isTrue);
  });

  test('hasCredentials is false when the access token is missing', () async {
    when(() => store.read(SecureTokenStorage.accessTokenKey))
        .thenAnswer((_) async => '');

    expect(await storage.hasCredentials(), isFalse);
  });

  test('clearAll deletes every stored value', () async {
    when(() => store.deleteAll()).thenAnswer((_) async {});

    await storage.clearAll();

    verify(() => store.deleteAll()).called(1);
  });
}
