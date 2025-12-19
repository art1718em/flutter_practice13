import 'package:flutter_practice13/core/models/user_model.dart';
import 'package:flutter_practice13/core/storage/secure_storage_helper.dart';
import 'package:flutter_practice13/data/datasources/auth/user_dto.dart';
import 'package:flutter_practice13/data/datasources/auth/user_mapper.dart';
import 'package:uuid/uuid.dart';

class AuthLocalDataSource {
  final _uuid = const Uuid();
  final SecureStorageHelper _secureStorage;

  AuthLocalDataSource(this._secureStorage);

  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final userCredentials = await _secureStorage.getUserCredentials(email);

    if (userCredentials == null) {
      throw Exception('Пользователь не найден');
    }

    if (userCredentials['password'] != password) {
      throw Exception('Неверный пароль');
    }

    final user = UserDto(
      id: userCredentials['id']!,
      email: email,
      password: password,
      name: userCredentials['name']!,
      registrationDate: userCredentials['registrationDate']!,
    );

    final authToken = _uuid.v4();
    final refreshToken = _uuid.v4();

    await _secureStorage.saveAuthToken(authToken);
    await _secureStorage.saveRefreshToken(refreshToken);
    await _secureStorage.saveUserId(user.id);
    await _secureStorage.saveUserEmail(user.email);
    await _secureStorage.saveUserName(user.name);

    return user.toModel();
  }

  Future<UserModel> register(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final existingUser = await _secureStorage.getUserCredentials(email);

    if (existingUser != null) {
      throw Exception('Пользователь с таким email уже существует');
    }

    final userDto = UserDto(
      id: _uuid.v4(),
      email: email,
      password: password,
      name: name,
      registrationDate: DateTime.now().toIso8601String(),
    );

    await _secureStorage.saveUserCredentials(
      email: userDto.email,
      password: userDto.password,
      userId: userDto.id,
      name: userDto.name,
      registrationDate: userDto.registrationDate,
    );

    final authToken = _uuid.v4();
    final refreshToken = _uuid.v4();

    await _secureStorage.saveAuthToken(authToken);
    await _secureStorage.saveRefreshToken(refreshToken);
    await _secureStorage.saveUserId(userDto.id);
    await _secureStorage.saveUserEmail(userDto.email);
    await _secureStorage.saveUserName(userDto.name);

    return userDto.toModel();
  }

  Future<void> logout() async {
    await _secureStorage.deleteAuthToken();
    await _secureStorage.deleteRefreshToken();
    await _secureStorage.deleteUserId();
    await _secureStorage.deleteUserEmail();
    await _secureStorage.deleteUserName();
  }

  Future<UserModel?> getCurrentUser() async {
    final userId = await _secureStorage.getUserId();
    final hasToken = await _secureStorage.hasAuthToken();

    if (userId == null || !hasToken) {
      return null;
    }

    final email = await _secureStorage.getUserEmail();
    final name = await _secureStorage.getUserName();

    if (email == null || name == null) {
      return null;
    }

    final userDto = UserDto(
      id: userId,
      email: email,
      password: '',
      name: name,
      registrationDate: DateTime.now().toIso8601String(),
    );

    return userDto.toModel();
  }
}

