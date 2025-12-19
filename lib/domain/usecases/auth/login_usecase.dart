import 'package:flutter_practice13/core/models/user_model.dart';
import 'package:flutter_practice13/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserModel?> call(String email, String password) {
    return repository.login(email, password);
  }
}

