import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static SecureStorageHelper? _instance;
  static FlutterSecureStorage? _storage;

  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';

  SecureStorageHelper._();

  static Future<SecureStorageHelper> getInstance() async {
    if (_instance == null) {
      _instance = SecureStorageHelper._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    const androidOptions = AndroidOptions(
      encryptedSharedPreferences: true,
    );

    const iosOptions = IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    );

    _storage = const FlutterSecureStorage(
      aOptions: androidOptions,
      iOptions: iosOptions,
    );
  }

  Future<void> saveAuthToken(String token) async {
    if (_storage == null) await _init();
    await _storage!.write(key: _keyAuthToken, value: token);
  }

  Future<String?> getAuthToken() async {
    if (_storage == null) await _init();
    return await _storage!.read(key: _keyAuthToken);
  }

  Future<void> deleteAuthToken() async {
    if (_storage == null) await _init();
    await _storage!.delete(key: _keyAuthToken);
  }

  Future<void> saveRefreshToken(String token) async {
    if (_storage == null) await _init();
    await _storage!.write(key: _keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    if (_storage == null) await _init();
    return await _storage!.read(key: _keyRefreshToken);
  }

  Future<void> deleteRefreshToken() async {
    if (_storage == null) await _init();
    await _storage!.delete(key: _keyRefreshToken);
  }

  Future<void> saveUserId(String userId) async {
    if (_storage == null) await _init();
    await _storage!.write(key: _keyUserId, value: userId);
  }

  Future<String?> getUserId() async {
    if (_storage == null) await _init();
    return await _storage!.read(key: _keyUserId);
  }

  Future<void> deleteUserId() async {
    if (_storage == null) await _init();
    await _storage!.delete(key: _keyUserId);
  }

  Future<void> saveUserEmail(String email) async {
    if (_storage == null) await _init();
    await _storage!.write(key: _keyUserEmail, value: email);
  }

  Future<String?> getUserEmail() async {
    if (_storage == null) await _init();
    return await _storage!.read(key: _keyUserEmail);
  }

  Future<void> deleteUserEmail() async {
    if (_storage == null) await _init();
    await _storage!.delete(key: _keyUserEmail);
  }

  Future<void> saveUserName(String name) async {
    if (_storage == null) await _init();
    await _storage!.write(key: _keyUserName, value: name);
  }

  Future<String?> getUserName() async {
    if (_storage == null) await _init();
    return await _storage!.read(key: _keyUserName);
  }

  Future<void> deleteUserName() async {
    if (_storage == null) await _init();
    await _storage!.delete(key: _keyUserName);
  }

  Future<void> clearAll() async {
    if (_storage == null) await _init();
    await _storage!.deleteAll();
  }

  Future<bool> hasAuthToken() async {
    if (_storage == null) await _init();
    final token = await _storage!.read(key: _keyAuthToken);
    return token != null;
  }

  Future<void> saveUserCredentials({
    required String email,
    required String password,
    required String userId,
    required String name,
    required String registrationDate,
  }) async {
    if (_storage == null) await _init();
    await _storage!.write(key: 'user_${email}_password', value: password);
    await _storage!.write(key: 'user_${email}_id', value: userId);
    await _storage!.write(key: 'user_${email}_name', value: name);
    await _storage!.write(key: 'user_${email}_registration_date', value: registrationDate);
  }

  Future<Map<String, String>?> getUserCredentials(String email) async {
    if (_storage == null) await _init();
    final password = await _storage!.read(key: 'user_${email}_password');
    if (password == null) return null;

    final userId = await _storage!.read(key: 'user_${email}_id');
    final name = await _storage!.read(key: 'user_${email}_name');
    final registrationDate = await _storage!.read(key: 'user_${email}_registration_date');

    return {
      'password': password,
      'id': userId ?? '',
      'name': name ?? '',
      'registrationDate': registrationDate ?? '',
    };
  }
}

