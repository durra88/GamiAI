import 'package:core/src/storage/secure_key_value_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [SecureKeyValueStore] backed by [FlutterSecureStorage].
final class FlutterSecureKeyValueStore implements SecureKeyValueStore {
  new({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
